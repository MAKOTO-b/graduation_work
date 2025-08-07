class RmdChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :rmd_chat_room

  validates :partner_id, presence: true
  validates :content, presence: true
end
