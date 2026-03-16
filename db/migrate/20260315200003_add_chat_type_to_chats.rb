class AddChatTypeToChats < ActiveRecord::Migration[8.1]
  def change
    add_column :chats, :chat_type, :string, default: "generic", null: false
    add_index :chats, :chat_type
  end
end
