class Message < ApplicationRecord
  acts_as_message tool_calls_foreign_key: :message_id
  has_many_attached :attachments
  broadcasts_to ->(message) { "chat_#{message.chat_id}" }

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
      target: "message_#{id}_content",
      partial: "messages/content",
      locals: { content: content }
  end

  def broadcast_replace_message
    broadcast_replace_to "chat_#{chat_id}",
      target: "message_#{id}",
      partial: "messages/message",
      locals: { message: self }
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id chat_id role content created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[chat]
  end
end
