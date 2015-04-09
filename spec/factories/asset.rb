FactoryGirl.define do
  factory :image do
    image do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures',
                        'files', 'test1500white.png'), 'image/png')
    end
    trait :with_artefact do
      artefact
    end
  end
end
