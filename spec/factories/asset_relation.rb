FactoryGirl.define do
  factory :asset_relation do
    asset factory: :image

    trait :with_location do
      relatable factory: :location
    end
    
    trait :with_reconstruction do
      relatable factory: :reconstruction
    end
  end
end
