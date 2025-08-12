FactoryBot.define do
  factory :grumble do
    association :user
    sequence(:content) { |n| "This is test grumble #{n}" }
  end
end