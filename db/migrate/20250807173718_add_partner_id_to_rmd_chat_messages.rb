class AddPartnerIdToRmdChatMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :rmd_chat_messages, :partner_id, :integer
  end
end
