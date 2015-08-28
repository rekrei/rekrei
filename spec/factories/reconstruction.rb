FactoryGirl.define do
  factory :reconstruction do
    name { Faker::Address.city }
    location
    trait :with_cover_image do
      cover_image { FactoryGirl.create(:image) }
    end
  end
end
