FactoryGirl.define do
  factory :image do
    location

    trait :with_stubbed_image do
      image_file_name { 'test1500white.png' }
      image_content_type 'image/jpeg'
      image_file_size 256
    end

    trait :with_stubbed_image_and_files do
      image_file_name { 'test1500white.png' }
      image_content_type 'image/jpeg'
      image_file_size 256
      after(:create) do |asset|
        image_file = Rails.root.join("spec/fixtures/files/test1500white.png")

        # cp test image to direcotries
        [:original, :medium, :thumb].each do |size|
          dest_path = asset.image.path(size)
          `mkdir -p #{File.dirname(dest_path)}`
          `cp #{image_file} #{dest_path}`
        end
      end
    end

    trait :with_image do
      image do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'fixtures',
                          'files', 'test1500white.png'), 'image/png')
      end
    end

    trait :with_reconstruction do
      after(:create) do |instance|
        create :asset_relation, :with_reconstruction, asset: instance
      end
    end

    trait :with_artefact do
      artefact
    end
  end
end
