class ParseFileToDatabaseJob < ApplicationJob
  queue_as :default
  MAX_RETRIES = 3

  def perform(the_learning_path, original_filename)
    ActiveRecord::Base.connection_pool.with_connection do
      sample_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Rails.root.join('public', 'uploads', original_filename).open,
        filename: original_filename,
        type: 'text/plain'
      )

      counter = 0

      File.open(sample_file) do |file|
        begin
          file.each do |line|
            retry_count = 0
            begin
              next unless line.valid_encoding?
              next if line.at(0) =~ /\d/ || line.strip.empty?

              line.split(/!.?/).each do |a_line|
                counter += 1

                if Expression.exists?(body: a_line.strip)
                  next
                elsif Translation.exists?(learning_path_id: the_learning_path.id, expression_in_target_language_id: Expression.find_by(body: a_line.strip)&.id) || a_line.strip.empty?
                  next
                end

                the_expression = Expression.find_or_initialize_by(body: a_line.strip)
                the_expression.language_id = Language.find(the_learning_path.target_language_id).id
                the_expression.save

                next if Translation.exists?(learning_path_id: the_learning_path.id, expression_in_target_language_id: the_expression.id)

                expression_to_translate = the_expression.body
                source_language = Language.find(the_learning_path.target_language_id).shortcode
                target_language = Language.find(the_learning_path.base_language_id).shortcode
                api_url = ENV["api_url"]

                request_data = {
                  q: expression_to_translate,
                  source: source_language,
                  target: target_language,
                  format: 'text',
                  api_key: ''
                }

                response = HTTP.post(api_url, json: request_data, headers: { 'Content-Type' => 'application/json' })

                if response.code.to_i == 200
                  translation = JSON.parse(response.body)
                  translated_expression = translation['translatedText']

                  new_expression = Expression.find_or_create_by(body: translated_expression)
                  new_expression.language_id = Language.find(the_learning_path.base_language_id).id
                  new_expression.save

                  translation = Translation.new(
                    learning_path_id: the_learning_path.id,
                    expression_in_base_language_id: new_expression.id,
                    expression_in_target_language_id: the_expression.id
                  )
                  translation.save
                else
                  puts "Error: #{response.code}"
                  puts response.body
                end
              end
            rescue PG::ConnectionBad => e
              Rails.logger.error("PG::ConnectionBad: #{e.message}")
              retry_count += 1
              retry if retry_count < MAX_RETRIES
            end
          end
        rescue StandardError => e
          Rails.logger.error("Error processing file: #{e.message}")
        ensure
          ActiveRecord::Base.connection_pool.release_connection
        end

        pp "#{counter} lines in movie"
      end
    end
  end
end
