class CreateRmdChatMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :rmd_chat_messages do |t|
      t.references :rmd_chat_room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.timestamps
    end
  end
end
