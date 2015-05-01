require 'rails_helper'

describe Reconstruction do
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should belong_to(:cover_image) }
  it { should belong_to(:location) }

  describe ".set_cover_image" do
    let(:image){ FactoryGirl.create(:image) }
    let(:reconstruction){ FactoryGirl.create(:reconstruction) }

    it "should update cover image" do
      reconstruction.set_cover_image(image)
      reconstruction.reload
      expect(reconstruction.cover_image).to eq image
    end
  end
end