
require "net/http"
require "json"
desc "Fill the database tables with some sample data"
task({ :drop_tables => :environment }) do
  if Rails.env.development?
    LearningPath.destroy_all
    Language.destroy_all
    User.destroy_all
  end
end
task({ :make_tables => :environment }) do
  ## make user
  user = User.new
  user.email = "Andrew@example.com"
  user.password = "password"
  user.save

  french = Language.new
  french.name = "French"
  french.shortcode = "fr"
  french.save

  english = Language.new
  english.name = "English"
  english.shortcode = "en"
  english.save

  learning_path = LearningPath.new
  learning_path.title = "Amelie Flashcards"
  learning_path.base_language_id = Language.find_by(name: "English").id
  learning_path.target_language_id = Language.find_by(name: "French").id
  ## add user_id
  learning_path.user_id = user.id
  learning_path.save
end
task({ :sample_data => :environment }) do
  sample_data_files = Array.new
  sample_data_file = ActionDispatch::Http::UploadedFile.new(tempfile: Rails.root.join("lib", "sample_data", "Amelie_Sample_Data.txt").open, filename: "Amelie_Sample_Data.txt", type: "text/plain")
  sample_data_file2 = ActionDispatch::Http::UploadedFile.new(tempfile: Rails.root.join("lib", "sample_data", "A Bout de Souffle.fre.srt").open, filename: "A Bout de Souffle.fre.srt", type: "text/plain")
  sample_data_files.push(sample_data_file)
  sample_data_files.push(sample_data_file2)
  sample_data_files.each do |sample_file|
  counter = 0
  File.open(sample_file) do |file|
    # pp file
    file.each do |line|
      #  pp line
      if !line.valid_encoding?
        next
      end
      if line.at(0) =~ /\d/
        next
      end
      line.split(/!.?/).each do |a_line|
        counter += 1
        
        #search database for word
        # if no record is returned
        # add word as record
        if !Expression.where(:body => a_line).first.nil? || a_line =~ /\d/
          next
        else
          the_expression = Expression.new
          the_expression.language_id = Language.find_by(name: "French").id
          the_expression.body = a_line
          the_expression.save
        end
      end
    end
  end
  pp "#{Expression.all.length} records created"
  pp "#{counter} lines in movie"
  # make translations queries
end
end
task({ :add_translations => :environment }) do
  api_url = "http://localhost:5000/translate"

  Expression.where(language_id: Language.find_by(:name => "French").id).all.each do |expression|
    if !Translation.find_by(:expression_in_target_language => expression).nil?
      next
    end
    expression_to_translate = expression.body
    source_language = "fr"
    target_language = "en"

    # Create a Hash with the request parameters
    request_data = {
      q: expression_to_translate,
      source: source_language,
      target: target_language,
      format: "text",
      api_key: ""
    }

    # Make the request
    response = HTTP.post(api_url, json: request_data, headers: { "Content-Type" => "application/json" })
    if response.code.to_i == 200
      # Parse the JSON response
      translation = JSON.parse(response.body)
      translated_expression = translation["translatedText"]
      #puts "Translation: #{translated_expression}"

      if Expression.where(body: translated_expression).where(language_id: Language.where(name: "French").first.id).first.nil?
        new_expression = Expression.new
        new_expression.body = translated_expression
        new_expression.language_id = Language.find_by(name: "English").id
        new_expression.save

        if Translation.where(expression_in_base_language: translated_expression).where(expression_in_target_language: translated_expression).first.nil?
          translation = Translation.new
          #error at learning_path
          translation.learning_path_id = LearningPath.find_by(title: "Amelie Flashcards").id
          translation.expression_in_base_language_id = new_expression.id
          translation.expression_in_target_language_id = expression.id
          # pp 'here'
          translation.save
        end
      end
    else
      puts "Error: #{response.code}"
      puts response.body
    end
  end
end
