class ChangeDataContentToColumn < ActiveRecord::Migration[7.2]
  def change
    change_column :chat_massages, :content, :text
  end
end
