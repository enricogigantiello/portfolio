class Chat < ApplicationRecord
  acts_as_chat messages_foreign_key: :chat_id

  PORTFOLIO_TYPE = "portfolio"

  belongs_to :user, optional: true

  scope :portfolio, -> { where(chat_type: PORTFOLIO_TYPE) }

  def portfolio?
    chat_type == PORTFOLIO_TYPE
  end
end
