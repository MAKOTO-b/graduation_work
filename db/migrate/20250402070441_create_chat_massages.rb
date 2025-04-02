class CreateChatMassages < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_massages do |t|
      t.references :chat_room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :email,null: false
      t.timestamps
    end
  end
end
