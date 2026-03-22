# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    panel "Visitor Chats" do
      visitor_chats = Chat.includes(:user, :messages)
                          .where(users: { role: :visitor })
                          .order(created_at: :desc)

      if visitor_chats.any?
        table_for visitor_chats do
          column("Chat") { |chat| link_to "Chat ##{chat.id}", admin_chat_path(chat) }
          column("User") { |chat| chat.user&.email }
          column("Type") { |chat| chat.chat_type }
          column("Last Question") do |chat|
            last_user_msg = chat.messages.select { |m| m.role == "user" }.last
            last_user_msg&.content&.truncate(120)
          end
          column("Started At") { |chat| chat.created_at.strftime("%Y-%m-%d %H:%M") }
        end
      else
        para "No visitor chats yet."
      end
    end
  end # content
end
