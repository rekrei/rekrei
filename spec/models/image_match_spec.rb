require 'rails_helper'

describe ImageMatch do
  it { should respond_to(:matches) }
  it { should respond_to(:has_error) }
  it { should respond_to(:time_to_match) }
  it { should belong_to(:parent_image) }
  it { should belong_to(:comparison_image) }

  context "image relationships" do
    let(:parent_image) { build_stubbed(:image) }
    let(:comparison_image) { build_stubbed(:image) }
    let(:image_match) { build_stubbed(:image_match, parent_image: parent_image, comparison_image: comparison_image) }

    subject{ image_match }
    it { expect(image_match.parent_image).to eq parent_image }
    it { expect(image_match.comparison_image).to eq comparison_image }
  end

  context "compare two images" do
    let!(:parent_image) { create(:image, image: nil) }
    let!(:comparison_image) { create(:image, image: nil) }
    let(:images) { create_pair(:image, image: nil) }
    let!(:image_match_1) { create(:image_match, parent_image: parent_image, comparison_image: comparison_image) }
    let!(:image_match_2) { create(:image_match, parent_image: comparison_image, comparison_image: parent_image) }

    it "should create image matches for both images" do
      expect(ImageTester).to receive(:compare).with(images).and_return({:matches=>1000, :error=>false, :time=>0.200})
      expect(ImageTester).to receive(:compare).with(images.reverse).and_return({:matches=>950, :error=>false, :time=>0.200})
      expect {
        ImageMatch.compare_images(images)
      }.to change(ImageMatch, :count).by(2)
    end

    it "should only create new matches" do
      expect(ImageTester).to_not receive(:compare).with([parent_image,comparison_image])
      expect(ImageTester).to_not receive(:compare).with([comparison_image,parent_image])
      expect {
        ImageMatch.compare_images([parent_image,comparison_image])
      }.to change(ImageMatch, :count).by(0)
    end
  end
  
  context "image match results" do
    let!(:images) { create_pair(:image, image: nil) }
    subject(:image_matches) do
      expect(ImageTester).to receive(:compare).with(images).and_return({:matches=>1000, :error=>false, :time=>0.201})
      expect(ImageTester).to receive(:compare).with(images.reverse).and_return({:matches=>950, :error=>false, :time=>0.301})
      image_matches = ImageMatch.compare_images(images)
    end
    # images - set of two images to use for the comparison
    # images.first is the initial parent image
    # images.last is the initial comparison image
    it { expect(image_matches.count).to eq 2 }
    it { expect(image_matches.first.parent_image).to eq images.first }
    it { expect(image_matches.first.comparison_image).to eq images.last }
    it { expect(image_matches.last.parent_image).to eq images.last }
    it { expect(image_matches.last.comparison_image).to eq images.first }
    it { expect(image_matches.first.matches).to eq 1000 }
    it { expect(image_matches.last.matches).to eq 950 }
    it { expect(image_matches.first.time_to_match).to eq "0.201" }
    it { expect(image_matches.last.time_to_match).to eq "0.301" }
    it { expect(image_matches.first.has_error).to eq false }
    it { expect(image_matches.last.has_error).to eq false }
  end
end