class FlashcardsController < ApplicationController
  def show_question_card
    # fallback = LearningPath.where(:user_id => current_user.id).all.sample.id
    @learning_path_id = params.fetch('learning_path_id')
    render({ template: 'flashcards/question_card' })
  end

  def show_results
    @learning_path_id = params.fetch('learning_path_id')
    @first = params.fetch('question')
    second = params.fetch('selected_translation')

    @result = !Translation.where(expression_in_target_language_id: @first).where(expression_in_base_language_id: second).first.nil?
    unless @result
      Translation.where(learning_path_id: @learning_path_id).where(expression_in_target_language_id: @first).first.review_status = 0
    end
    render({ template: 'flashcards/result_card' })
  end

  def show_quiz_card
    @learning_path_id = params.fetch('learning_path_id')
    render({ template: 'flashcards/quiz_card' })
  end

  def show_quiz_results
    respond_to do |format|
      format.html { redirect_back fallback_location: root_url }
      format.json { head :no_content }

      format.js do
        render template: 'flashcards/show_results'
      end
    end
  end
end
