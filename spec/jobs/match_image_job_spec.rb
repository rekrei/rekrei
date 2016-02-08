require 'rails_helper'

RSpec.describe MatchImageJob, type: :job do
  context "match image job should create image matches" do
    let!(:location) { create(:location) }
    let!(:image_match) { create(:image_match, location: location) }
    let!(:unmatched_image) { create(:image, location: location) }

    it { expect(Image.count).to eq 3 }
    it { expect(unmatched_image.unmatched_images.count).to eq 2 }

    it "should create image matches for image" do
      expect {
        allow(ImageTester).to receive(:compare).and_return({:matches=>1000, :error=>false, :time=>0.201})
        MatchImageJob.perform_now image: unmatched_image, unmatched_image: image_match.parent_image
      }.to change(ImageMatch, :count).by(2)
    end

  end

end
