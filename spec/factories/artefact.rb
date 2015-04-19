FactoryGirl.define do
  factory :artefact do
    name 'artefact'
    description 'description'
    museum_identifier 'm.m1'
    trait :with_image do
      association :image, factory: :image
    end
  end
end
