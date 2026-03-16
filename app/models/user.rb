class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  enum :role, { visitor: 1, owner: 0 }, prefix: true

  has_one :portfolio_chat, -> { where(chat_type: Chat::PORTFOLIO_TYPE) },
          class_name: "Chat", foreign_key: :user_id, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "email", "encrypted_password", "id", "id_value", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "portfolio_chat" ]
  end
end
