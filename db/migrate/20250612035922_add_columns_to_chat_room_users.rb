class AddColumnsToChatRoomUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :chat_room_users, :partner_id, :integer
    add_column :chat_room_users, :matching_status, :integer
  end
end
