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
