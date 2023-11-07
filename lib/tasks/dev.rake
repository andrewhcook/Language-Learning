desc "Fill the database tables with some sample data"

require "net/http"
require "json"
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
  french.save

  english = Language.new
  english.name = "English"
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
  sample_data_file = ActionDispatch::UploadedFile.new(tempfile: Rails.root.join("lib", "sample_data", "Amelie_Sample_Data.srt").open, filename: "Amelie_Sample_Data.srt", type: "text/plain")

  counter = 0
  File.open(sample_data_file) do |file|
    # pp file
    file.each do |line|
      #  pp line
      if !line.valid_encoding?
        next
      end
      if line.at(0) =~ /\d/
        next
      end
      line.split(" ").each do |a_word|
        counter += 1
        word = a_word.downcase.gsub(".", "").gsub(",", "").gsub("?", "").gsub("\"", "").gsub("!", "").gsub("(", "").gsub(")", "")
        #search database for word
        # if no record is returned
        # add word as record
        if !Word.where(:word => word).first.nil? || word =~ /\d/
          next
        else
          the_word = Word.new
          the_word.language_id = Language.find_by(name: "French").id
          the_word.word = word
          the_word.save
        end
      end
    end
  end
  pp "#{Word.all.length} records created"
  pp "#{counter} words in movie"
  # make translations queries
end
task({ :add_translations => :environment }) do
  api_url = "http://localhost:5000/"

  Word.where(language_id: Language.find_by(:name => "French").id).all.each do |word|
    if !Translation.find_by(:word_in_target_language => word).nil?
      next
    end
    word_to_translate = word.word
    source_language = "fr"
    target_language = "en"

    # Create a Hash with the request parameters
    request_data = {
      q: word_to_translate,
      source: source_language,
      target: target_language,
      format: "text",
    }

    request = Net::HTTP::Post.new(api_url)
    request["Content-Type"] = "application/json"
    request.body = request_data.to_json

    # Make the request
    response = HTTP.post(api_url, json: request_data, headers: { "Content-Type" => "application/json" })
    if response.code.to_i == 200
      pp "here"
      # Parse the JSON response
      translation = JSON.parse(response.body)
      translated_word = translation["translatedText"]
      puts "Translation: #{translated_text}"

      if Word.where(word: translated_word).where(language_id: Language.where(name: "French").first.id).first.nil?
        new_word = Word.new
        new_word.word = translated_word
        new_word.language_id = Language.find_by(name: "English").id
        new_word.save

        if Translation.where(word_in_base_language: translated_word).where(word_in_target_language: word).first.nil?
          translation = Translation.new
          #error at learning_path
          translation.learning_path_id = LearningPath.find_by(title: "Amelie Flashcards").id
          translation.word_in_base_language_id = new_word.id
          translation.word_in_target_language_id = word.id
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
