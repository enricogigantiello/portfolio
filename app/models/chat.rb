class Chat < ApplicationRecord
  acts_as_chat messages_foreign_key: :chat_id

  PORTFOLIO_TYPE = "portfolio"

  belongs_to :user, optional: true

  scope :portfolio, -> { where(chat_type: PORTFOLIO_TYPE) }

  def portfolio?
    chat_type == PORTFOLIO_TYPE
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id chat_type user_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user messages]
  end
end
