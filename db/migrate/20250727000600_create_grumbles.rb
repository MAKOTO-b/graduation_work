class CreateGrumbles < ActiveRecord::Migration[7.2]
  def change
    create_table :grumbles do |t|
      t.text :content
      t.integer :likes_count

      t.timestamps
    end
  end
end
