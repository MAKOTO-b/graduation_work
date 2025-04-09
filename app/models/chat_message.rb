class ChatMessage < ApplicationRecord
    belongs_to :user
    belongs_to :chat_room

    # createの後にコミットする { MessageBroadcastJobのperformを遅延実行 引数はself }
    after_create_commit { ChatMessageBroadcastJob.perform_later self }
end
