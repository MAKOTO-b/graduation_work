class RenameEmailColumnToContent < ActiveRecord::Migration[7.2]
  def change
    rename_column :chat_massages, :email, :content
  end
end
