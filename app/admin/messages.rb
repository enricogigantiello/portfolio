ActiveAdmin.register Message do
  menu priority: 9

  belongs_to :chat, optional: true

  actions :index, :show

  filter :chat_id
  filter :role, as: :select, collection: %w[user assistant tool]
  filter :created_at

  index do
    id_column
    column :chat do |msg|
      link_to "Chat ##{msg.chat_id}", admin_chat_path(msg.chat_id)
    end
    column :role
    column("Content") { |msg| msg.content&.truncate(150) }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :chat do |msg|
        link_to "Chat ##{msg.chat_id}", admin_chat_path(msg.chat_id)
      end
      row :role
      row :content
      row :input_tokens
      row :output_tokens
      row :cached_tokens
      row :created_at
      row :updated_at
    end
  end

  controller do
    def scoped_collection
      super.includes(:chat)
    end
  end
end
