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
    trait :with_artefact do
      artefact
    end
    trait :with_reconstruction do
      reconstruction
    end
  end
end
