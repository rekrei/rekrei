FactoryGirl.define do
  factory :image do
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures','files','test1500white.png'), 'image/png') }
    trait :with_artefact do
      artefact
    end
  end
end