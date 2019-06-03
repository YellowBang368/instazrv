FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@gmail.com" }
    sequence(:username) { |n| "username#{n}" }
  end
end
