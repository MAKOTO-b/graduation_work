FactoryBot.define do
  factory :rmd_chat_room_user do
    association :rmd_chat_room
    association :user
  end
end
