desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  if Rails.env.development?
    Word.destroy_all
  end
  sample_data_file = ActionDispatch::Http::UploadedFile.new(tempfile: Rails.root.join("lib", "sample_data", "Amelie_Sample_Data.srt").open, filename: "Amelie_Sample_Data.srt", type: "text/plain")
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
        word = a_word.downcase.gsub(".", "").gsub(",","").gsub("?","").gsub("\"", "").gsub("!", "").gsub("(", "").gsub(")", "")
        #search database for word
        # if no record is returned 
          # add word as record
          if !Word.where(:word => word).first.nil? || word =~/\d/
            next
        else 
          the_word = Word.new
          the_word.language_id = 1
          the_word.word = word
          the_word.save
        end
      end
    end
  end
  pp "#{Word.all.length} records created"
  pp "#{counter} words in movie"
end
