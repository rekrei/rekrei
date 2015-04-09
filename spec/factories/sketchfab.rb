FactoryGirl.define do
  factory :sketchfab do
    bbcode Rails.root.join('spec', 'fixtures',
                           'files', 'bbcode.txt')
    trait :with_artefact do
      artefact
    end
  end
end
