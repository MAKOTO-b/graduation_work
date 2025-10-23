class AddIsReadToRmdChatMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :rmd_chat_messages, :is_read, :boolean, default: false, null: false
  end
end
