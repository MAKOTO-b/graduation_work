class RmdChatRoom < ApplicationRecord
  has_many :rmd_chat_room_users
  has_many :rmd_chat_messages
  has_many :users, through: :rmd_chat_room_users
end
