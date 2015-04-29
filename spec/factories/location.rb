FactoryGirl.define do
  factory :location do
    name { Faker::Address.city }
    lat { Faker::Address.latitude }
    long { Faker::Address.longitude }
  end
end
