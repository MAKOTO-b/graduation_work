class RmdChatRoomUser < ApplicationRecord
  belongs_to :rmd_chat_room
  belongs_to :user

  # createの後にコミットする { MessageBroadcastJobのperformを遅延実行 引数はself }
  after_create_commit { RmdChatMessageBroadcastJob.perform_later self }

  validates :content, presence: true
end
