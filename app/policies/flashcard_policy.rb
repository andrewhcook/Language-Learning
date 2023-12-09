class FlashcardPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def show?
    current_user
  end

end
