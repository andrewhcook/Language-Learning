class TranslationPolicy < ApplicationPolicy
  attr_reader :user, :translation
  def initialize(user, translation)
    @user = user
    @translation = translation
  end

  def show?
    LearningPath.find(@translation.learning_path_id).user_id == @user.id
  end

end
