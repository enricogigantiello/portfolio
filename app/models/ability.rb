# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Publicly accessible resources (no login required)
    can :read, Job
    can :read, Project
    can :read, Education
    can :read, Language
    can :show, :home

    return unless user.present?

    # Logged-in users can access their own portfolio chat and send messages to it
    can :show, Chat, chat_type: Chat::PORTFOLIO_TYPE, user_id: user.id
    can :create, Message, chat: { chat_type: Chat::PORTFOLIO_TYPE, user_id: user.id }

    return unless user.role_owner?

    # Owner can manage everything
    can :manage, :all
  end
end
