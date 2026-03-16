class PortfolioChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = find_or_create_portfolio_chat
    @message = @chat.messages.build
  end

  private

  def find_or_create_portfolio_chat
    current_user.portfolio_chat || create_portfolio_chat
  end

  def create_portfolio_chat
    current_user.create_portfolio_chat!(chat_type: Chat::PORTFOLIO_TYPE, model: "gpt-5-nano")
  end
end
