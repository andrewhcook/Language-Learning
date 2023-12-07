class LearningPathPolicy
  attr_reader :user, :learning_path


  def initialize(user, learning_path)
    @user = user
    @learning_path = learning_path
  end

  def show?
    user.id == learning_path.user_id
  end
end
