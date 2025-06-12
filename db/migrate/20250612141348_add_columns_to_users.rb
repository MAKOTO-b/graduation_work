class AddColumnsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :matching_status, :integer
  end
end
