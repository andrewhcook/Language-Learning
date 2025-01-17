class TranslationsController < ApplicationController
  before_action :set_translation, only: %i[show update destroy]
  before_action :ensure_user_is_authorized, only: %i[show edit update destroy]

  def show
    the_id = params.fetch('path_id')

    matching_translations = Translation.where({ id: the_id })

    @the_translation = matching_translations.at(0)

    render({ template: 'translations/show' })
  end

  def create
    the_translation = Translation.new
    the_translation.expression_in_base_language_id = params.fetch('query_expression_in_base_language_id')
    the_translation.expression_in_target_language_id = params.fetch('query_expression_in_target_language_id')
    the_translation.learning_path_id = params.fetch('query_learning_path_id')

    if the_translation.valid?
      the_translation.save
      redirect_to('/translations', { notice: 'Translation created successfully.' })
    else
      redirect_to('/translations', { alert: the_translation.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch('path_id')
    the_translation = Translation.where({ id: the_id }).at(0)

    the_translation.expression_in_base_language_id = params.fetch('query_expression_in_base_language_id')
    the_translation.expression_in_target_language_id = params.fetch('query_expression_in_target_language_id')
    the_translation.learning_path_id = params.fetch('query_learning_path_id')

    if the_translation.valid?
      the_translation.save
      redirect_to("/translations/#{the_translation.id}", { notice: 'Translation updated successfully.' })
    else
      redirect_to("/translations/#{the_translation.id}", { alert: the_translation.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch('path_id')
    the_translation = Translation.where({ id: the_id }).at(0)

    the_translation.destroy

    redirect_to('/translations', { notice: 'Translation deleted successfully.' })
  end

  def update_status
    matching_translations = Translation.where({ id: params['id'] })
    the_translation = matching_translations.at(0)
    the_translation.review_status = params['review_status'].to_i
    the_translation.save
    # redirect_to("/flashcards/quiz")
  end

  def need_review_show
    render({ template: 'translations/need_to_review' })
  end

  def to_see_again
    render({ template: 'translations/to_see_again' })
  end

  private

  def set_translation
    @translation = Translation.find(params[:path_id])
  end

  def ensure_user_is_authorized
    return if TranslationPolicy.new(current_user, @translation).show?

    redirect_back fallback_location: '/learning_paths'
  end
end
