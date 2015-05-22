FactoryGirl.define do
  factory :asset_relation do
    asset factory: :image
    
    trait :with_reconstruction do
      reconstruction
    end
  end
end
