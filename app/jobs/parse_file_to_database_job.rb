class ParseFileToDatabaseJob < ApplicationJob
  queue_as :default

  def perform(the_learning_path, original_filename)
    # Do something later

      
      sample_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Rails.root.join('public', 'uploads',
                                  original_filename).open, filename: original_filename, type: 'text/plain'
      )
      counter = 0
      File.open(sample_file) do |file|
        # pp file
        file.each do |line|
          #  pp line
          next unless line.valid_encoding?
          next if line.at(0) =~ /\d/

          line.split(/!.?/).each do |a_line|
            counter += 1
            next if !Expression.where(body: a_line).first.nil? || a_line =~ /\d/

            the_expression = Expression.new
            the_expression.language_id = Language.find(the_learning_path.target_language_id).id
            the_expression.body = a_line
            the_expression.save

            # add translation queries
            api_url = 'http://localhost:5000/translate'
            next unless Translation.where(:learning_path_id => the_learning_path.id).find_by(expression_in_target_language: the_expression).nil?

            expression_to_translate = the_expression.body
            source_language = Language.find(the_learning_path.target_language_id).shortcode
            target_language = Language.find(the_learning_path.base_language_id).shortcode
            request_data = {
              q: expression_to_translate,
              source: source_language,
              target: target_language,
              format: 'text',
              api_key: ''
            }
            response = HTTP.post(api_url, json: request_data, headers: { 'Content-Type' => 'application/json' })
            if response.code.to_i == 200
              # Parse the JSON response
              translation = JSON.parse(response.body)
              translated_expression = translation['translatedText']
              puts "Translation: #{translated_expression}"

              new_expression = Expression.new
              new_expression.body = translated_expression
              new_expression.language_id = Language.find(the_learning_path.base_language_id).id
              new_expression.save

              translation = Translation.new
              # error at learning_path
              translation.learning_path_id = the_learning_path.id
              translation.expression_in_base_language_id = new_expression.id
              translation.expression_in_target_language_id = the_expression.id
              # pp 'here'
              translation.save

            else
              puts "Error: #{response.code}"
              puts response.body
            end
          end

        end
          pp "#{Expression.all.length} records created"
          pp "#{counter} lines in movie"
      end
    
  end
end
