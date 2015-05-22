FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    confirmed_at Time.zone.now

    trait :admin do
      admin true
    end
  end
end
