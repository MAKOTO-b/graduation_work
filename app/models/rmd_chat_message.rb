class RmdChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :rmd_chat_room

  # データを保存後にRmdChatMeesageBroadcastJobを実行
  after_create_commit { RmdChatMessageBroadcastJob.perform_later self }
  
  validates :content, presence: true
end
