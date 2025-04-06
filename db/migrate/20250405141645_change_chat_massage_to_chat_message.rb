class ChangeChatMassageToChatMessage < ActiveRecord::Migration[7.2]
  def change
    rename_table :chat_massages, :chat_messages
  end
end
