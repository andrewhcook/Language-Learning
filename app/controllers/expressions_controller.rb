class ExpressionsController < ApplicationController
  def index
    matching_expressions = Expression.all

    @list_of_expressions = matching_expressions.order({ :created_at => :desc })

    render({ :template => "expressions/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_expressions = Expression.where({ :id => the_id })

    @the_expression = matching_expressions.at(0)

    render({ :template => "expressions/show" })
  end

  def create
    the_expression = Expression.new
    the_expression.body = params.fetch("query_body")
    the_expression.language_id = params.fetch("query_language_id")

    if the_expression.valid?
      the_expression.save
      redirect_to("/expressions", { :notice => "Expression created successfully." })
    else
      redirect_to("/expressions", { :alert => the_expression.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_expression = Expression.where({ :id => the_id }).at(0)

    the_expression.body = params.fetch("query_body")
    the_expression.language_id = params.fetch("query_language_id")

    if the_expression.valid?
      the_expression.save
      redirect_to("/expressions/#{the_expression.id}", { :notice => "Expression updated successfully."} )
    else
      redirect_to("/expressions/#{the_expression.id}", { :alert => the_expression.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_expression = Expression.where({ :id => the_id }).at(0)

    the_expression.destroy

    redirect_to("/expressions", { :notice => "Expression deleted successfully."} )
  end
end
