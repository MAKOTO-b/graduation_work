class RmdChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :rmd_chat_room

  validates :content, presence: true
end
