class AddChatbotDailyLimitToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :chatbot_messages_count, :integer, null: false, default: 0
    add_column :users, :chatbot_messages_count_on, :date
  end
end
