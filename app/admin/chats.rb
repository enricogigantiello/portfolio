ActiveAdmin.register Chat do
  menu priority: 8

  actions :index, :show

  filter :chat_type
  filter :user_email, as: :string, label: "User Email"
  filter :created_at

  index do
    id_column
    column :user do |chat|
      chat.user&.email
    end
    column :chat_type
    column("Messages") { |chat| chat.messages.count }
    column("Last Question") do |chat|
      last_user_msg = chat.messages.where(role: "user").last
      last_user_msg&.content&.truncate(120)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :chat_type
      row :user do |chat|
        chat.user ? link_to(chat.user.email, admin_user_path(chat.user)) : "-"
      end
      row :created_at
      row :updated_at
    end

    panel "Messages" do
      table_for chat.messages.order(:created_at) do
        column :id do |msg|
          link_to msg.id, admin_message_path(msg)
        end
        column :role
        column("Content") { |msg| msg.content&.truncate(200) }
        column :created_at
      end
    end
  end

  controller do
    def scoped_collection
      super.includes(:user, :messages)
    end
  end
end
