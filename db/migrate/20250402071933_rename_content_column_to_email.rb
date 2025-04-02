class RenameContentColumnToEmail < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :content, :email
  end
end
