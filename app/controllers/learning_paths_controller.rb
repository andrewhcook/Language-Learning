class LearningPathsController < ApplicationController
  def index
    matching_learning_paths = LearningPath.all

    @list_of_learning_paths = matching_learning_paths.order({ :created_at => :desc })

    render({ :template => "learning_paths/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_learning_paths = LearningPath.where({ :id => the_id })

    @the_learning_path = matching_learning_paths.at(0)

    render({ :template => "learning_paths/show" })
  end

  def create
    
        the_learning_path = LearningPath.new
        the_learning_path.user_id = params.fetch("query_user_id")
        the_learning_path.base_language_id = params.fetch("query_base_language_id")
        the_learning_path.target_language_id = params.fetch("query_target_language_id")
        
        if the_learning_path.valid?
          the_learning_path.save
          redirect_to("/learning_paths", { :notice => "Learning path created successfully." })
        else
          redirect_to("/learning_paths", { :alert => the_learning_path.errors.full_messages.to_sentence })
        end
        uploaded_file = params[:file]
        pp params
        pp uploaded_file
        if !uploaded_file.nil?
          # Process the uploaded file here
          # You can save it to a specific directory or perform any other processing.
          # For example, you can save it to the public/uploads directory:
          File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
            file.write(uploaded_file.read)
          end
          sample_file = ActionDispatch::Http::UploadedFile.new(tempfile: Rails.root.join('public', 'uploads', uploaded_file.original_filename).open, filename: uploaded_file.original_filename, type: "text/plain")
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
                  the_expression.language_id = Language.find(the_learning_path.target_language_id).id
                  the_expression.body = a_line
                  the_expression.save

                  # add translation queries
                  api_url = "http://localhost:5000/translate"
                  if !Translation.find_by(:expression_in_target_language => the_expression).nil?
                    next
                  end
                  expression_to_translate = the_expression.body
                  source_language = Language.find(the_learning_path.target_language_id).shortcode
                  target_language = Language.find(the_learning_path.base_language_id).shortcode
                  request_data = {
                q: expression_to_translate,
                source: source_language,
                target: target_language,
                format: "text",
                api_key: ""
              }
              response = HTTP.post(api_url, json: request_data, headers: { "Content-Type" => "application/json" })
              if response.code.to_i == 200
                # Parse the JSON response
                translation = JSON.parse(response.body)
                translated_expression = translation["translatedText"]
                puts "Translation: #{translated_expression}"
          
          
                  new_expression = Expression.new
                  new_expression.body = translated_expression
                  new_expression.language_id = Language.find(the_learning_path.base_language_id).id
                  new_expression.save
          
                    translation = Translation.new
                    #error at learning_path
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
           ##
              
          
              # Make the request
            
            end
          end
        else
          flash[:error] = 'No file selected for upload.'
        end
      end


  def update
    the_id = params.fetch("path_id")
    the_learning_path = LearningPath.where({ :id => the_id }).at(0)

    the_learning_path.user_id = params.fetch("query_user_id")
    the_learning_path.base_language_id = params.fetch("query_base_language_id")
    the_learning_path.target_language_id = params.fetch("query_target_language_id")

    if the_learning_path.valid?
      the_learning_path.save
      redirect_to("/learning_paths/#{the_learning_path.id}", { :notice => "Learning path updated successfully."} )
    else
      redirect_to("/learning_paths/#{the_learning_path.id}", { :alert => the_learning_path.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_learning_path = LearningPath.where({ :id => the_id }).at(0)

    the_learning_path.destroy

    redirect_to("/learning_paths", { :notice => "Learning path deleted successfully."} )
  end
end
