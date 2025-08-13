FactoryBot.define do
  factory :rmd_chat_message do
    association :user
    association :rmd_chat_room
    sequence(:content) { |n| "Test message #{n}" }
  end
end
