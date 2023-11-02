class WordsController < ApplicationController
  def index
    matching_words = Word.all

    @list_of_words = matching_words.order({ :created_at => :desc })

    render({ :template => "words/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_words = Word.where({ :id => the_id })

    @the_word = matching_words.at(0)

    render({ :template => "words/show" })
  end

  def create
    the_word = Word.new
    the_word.language_id = params.fetch("query_language_id")
    the_word.word = params.fetch("query_word")

    if the_word.valid?
      the_word.save
      redirect_to("/words", { :notice => "Word created successfully." })
    else
      redirect_to("/words", { :alert => the_word.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_word = Word.where({ :id => the_id }).at(0)

    the_word.language_id = params.fetch("query_language_id")
    the_word.word = params.fetch("query_word")

    if the_word.valid?
      the_word.save
      redirect_to("/words/#{the_word.id}", { :notice => "Word updated successfully."} )
    else
      redirect_to("/words/#{the_word.id}", { :alert => the_word.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_word = Word.where({ :id => the_id }).at(0)

    the_word.destroy

    redirect_to("/words", { :notice => "Word deleted successfully."} )
  end
end
