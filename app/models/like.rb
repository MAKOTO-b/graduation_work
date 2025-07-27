class Like < ApplicationRecord
  belongs_to :user
  belongs_to :grumble
  validates :user_id, uniqueness: { scope: :grumble_id }
end
