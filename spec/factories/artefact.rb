FactoryGirl.define do
  factory :artefact do
    name 'artefact'
    description 'description'
    museum_identifier 'm.m1'
    trait :with_image do
      association :asset, factory: :image
    end
  end
end
