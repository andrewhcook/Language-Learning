class FlashcardsController < ApplicationController
  
  def show_question_card

    render({template: 'flashcards/question_card'})
  end

  def show_results

    @first = params.fetch("question")
    second = params.fetch("selected_translation")

    @result = !Translation.where(expression_in_target_language_id: @first).where(expression_in_base_language_id: second).first.nil?

    render({template: 'flashcards/result_card'})
  end


end
