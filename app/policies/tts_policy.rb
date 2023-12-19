class TtsPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def trigger?
    # could use ActiveSupport#present?
    # @user.present?
    return !@user.nil?
end
end
