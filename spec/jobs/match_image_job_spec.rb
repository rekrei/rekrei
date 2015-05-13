require 'rails_helper'

RSpec.describe MatchImageJob, type: :job do
  context "match image job should create image matches" do
    let!(:image_match) { create(:image_match) }
    let!(:unmatched_image) { create(:image) }

    it { expect(Image.count).to eq 3 }
    it { expect(unmatched_image.unmatched_images.count).to eq 2 }

    it "should create image matches for image" do
      expect { 
        MatchImageJob.perform_now image: unmatched_image, unmatched_image: image_match.parent_image
      }.to change(ImageMatch, :count).by(2)
    end

  end

end
