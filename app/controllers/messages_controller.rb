class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    return unless content.present?

    if @chat.portfolio?
      PortfolioChatResponseJob.perform_later(@chat.id, content, I18n.locale.to_s)
    else
      ChatResponseJob.perform_later(@chat.id, content)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat }
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])

    unless current_user.role_owner? || (@chat.portfolio? && @chat.user_id == current_user.id)
      redirect_to root_path, alert: "Not authorized." and return
    end
  end

  def content
    params[:message][:content]
  end
end
