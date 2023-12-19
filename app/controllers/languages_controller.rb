class LanguagesController < ApplicationController
  def index
    matching_languages = Language.all

    @list_of_languages = matching_languages.order({ created_at: :desc })

    render({ template: 'languages/index' })
  end

  def show
    the_id = params.fetch('path_id')

    # could use language = Language.find_by(id: the_id)
    matching_languages = Language.where({ id: the_id })

    @the_language = matching_languages.at(0)

    # don't need this render, it's assumed since we're in show action 😎
    render({ template: 'languages/show' })
  end

  def create
    the_language = Language.new
    the_language.name = params.fetch('query_name')
    the_language.shortcode = params.fetch('query_shortcode')

    if the_language.valid?
      the_language.save
      redirect_to('/languages', { notice: 'Language created successfully.' })
    else
      redirect_to('/languages', { alert: the_language.errors.full_messages.to_sentence })
    end
  end
end
