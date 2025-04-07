class CreateChatRoomUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_room_users do |t|
      t.timestamps
      t.references :chat_room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end
  end
end
