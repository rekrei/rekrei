FactoryGirl.define do
  factory :image do
    location
    trait :with_image do
      image do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'fixtures',
                          'files', 'test1500white.png'), 'image/png')
      end
    end

    trait :with_reconstruction do
      after(:create) do |instance|
        create :asset_relation, asset: instance
      end
    end

    trait :with_artefact do
      artefact
    end
  end
end
