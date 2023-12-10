class TtsPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def trigger?
    return !@user.nil?
end
end
