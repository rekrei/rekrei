FactoryGirl.define do
  # location_instance = FactoryGirl.create(:location)
  factory :image_match do
    matches 1000
    has_error false
    time_to_match 0.101
    location
    parent_image { create(:image, :with_stubbed_image, location: location) }
    comparison_image { create(:image, :with_stubbed_image, location: location) }
  end
end