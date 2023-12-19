class TranslationPolicy < ApplicationPolicy
  attr_reader :user, :translation

  def initialize(user, translation)
    @user = user
    @translation = translation
  end

  def show?
    # Could a user has_many :translations, through: learning_paths ?
    # Then you could do something like @user.translations.include? @translation
    LearningPath.find(@translation.learning_path_id).user_id == @user.id
  end
end
