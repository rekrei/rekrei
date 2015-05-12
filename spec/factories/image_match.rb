FactoryGirl.define do
  factory :image_match do
    matches 1000
    has_error false
    time_to_match 0.101
    parent_image { create(:image) }
    comparison_image { crate(:image) }
  end
end
