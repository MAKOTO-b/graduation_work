class RmdChatRoomUser < ApplicationRecord
    belongs_to :rmd_chat_room
    belongs_to :user
end
