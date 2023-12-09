class TtsPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def trigger?
    if @user
  end
end
