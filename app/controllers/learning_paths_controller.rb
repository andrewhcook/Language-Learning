class LearningPathsController < ApplicationController
  def index
    if current_user.nil?
      redirect_to('/users/sign_in')
    else
      render({ template: 'learning_paths/index' })
    end
  end

  def show
    the_id = params.fetch('path_id')

    matching_learning_paths = LearningPath.where({ id: the_id })

    @the_learning_path = matching_learning_paths.at(0)

    render({ template: 'learning_paths/show' })
  end

  def create
    the_learning_path = LearningPath.new
    the_learning_path.title = params.fetch('query_title_box')
    the_learning_path.user_id = current_user.id
    the_learning_path.base_language_id = Language.find( params.fetch('base_language_id_query_box')).id
    the_learning_path.target_language_id = Language.find(params.fetch('target_language_id_query_box')).id

    if the_learning_path.valid?
      the_learning_path.save
      redirect_to('/learning_paths', { notice: 'Learning path created successfully.' })
    else
      redirect_to('/learning_paths', { alert: the_learning_path.errors.full_messages.to_sentence })
    end

    uploaded_file = params[:file]
    pp uploaded_file

    if !uploaded_file.nil?
      File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
        file.write(uploaded_file.read)
      end
      ParseFileToDatabaseJob.perform_later(the_learning_path, uploaded_file.original_filename)
  else
    flash[:error] = 'No file selected for upload.'
  end
  end

  def update
    the_id = params.fetch('path_id')
    the_learning_path = LearningPath.where({ id: the_id }).at(0)

    the_learning_path.user_id = params.fetch('query_user_id')
    the_learning_path.base_language_id = params.fetch('query_base_language_id')
    the_learning_path.target_language_id = params.fetch('query_target_language_id')

    if the_learning_path.valid?
      the_learning_path.save
      redirect_to("/learning_paths/#{the_learning_path.id}", { notice: 'Learning path updated successfully.' })
    else
      redirect_to("/learning_paths/#{the_learning_path.id}",
                  { alert: the_learning_path.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch('path_id')
    the_learning_path = LearningPath.where({ id: the_id }).at(0)

    the_learning_path.destroy

    redirect_to('/learning_paths', { notice: 'Learning path deleted successfully.' })
  end

  def show_instructions
    render('/learning_paths/instructions')
  end

end
