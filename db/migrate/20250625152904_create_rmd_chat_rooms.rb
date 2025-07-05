class CreateRmdChatRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rmd_chat_rooms do |t|
      t.timestamps
    end
  end
end
