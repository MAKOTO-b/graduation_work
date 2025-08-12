FactoryBot.define do
  factory :like do
    association :user
    association :grumble
  end
end