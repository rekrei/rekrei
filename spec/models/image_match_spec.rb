require 'rails_helper'

describe ImageMatch do
  it { should respond_to(:matches) }
  it { should respond_to(:has_error) }
  it { should respond_to(:time_to_match) }
  it { should belong_to(:parent_image) }
  it { should belong_to(:comparison_image) }

  context "image relationships" do
    let(:location) { build_stubbed(:location) }
    let(:parent_image) { build_stubbed(:image, location: location) }
    let(:comparison_image) { build_stubbed(:image, location: location) }
    let(:image_match) { build_stubbed(:image_match, parent_image: parent_image, comparison_image: comparison_image, location: location) }

    subject{ image_match }
    it { expect(image_match.parent_image).to eq parent_image }
    it { expect(image_match.comparison_image).to eq comparison_image }
  end

  context "compare two images" do
    let!(:location) { create(:location) }
    let!(:parent_image) { create(:image, location: location) }
    let!(:comparison_image) { create(:image, location: location) }
    let(:images) { create_pair(:image, location: location) }
    let!(:image_match_1) { create(:image_match, parent_image: parent_image, comparison_image: comparison_image, location: location) }
    let!(:image_match_2) { create(:image_match, parent_image: comparison_image, comparison_image: parent_image, location: location) }

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
    let!(:location) { create(:location) }
    let!(:images) { create_pair(:image, location: location) }
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

  context "comparison sets location" do
    let(:location) { create(:location) }
    let(:images){ create_pair(:image, location: location) }
    subject(:image_matches) do
      expect(ImageTester).to receive(:compare).with(images).and_return({:matches=>1000, :error=>false, :time=>0.201})
      expect(ImageTester).to receive(:compare).with(images.reverse).and_return({:matches=>950, :error=>false, :time=>0.301})
      image_matches = ImageMatch.compare_images(images)
    end

    it { expect(image_matches.collect(&:location).uniq).to eq [location] }
  end

  context "comparison validates location" do
    let(:images){ create_pair(:image) }
    subject(:image_matches) do
      expect(ImageTester).to_not receive(:compare)
      image_matches = ImageMatch.compare_images(images)
    end

    it { expect(image_matches).to eq false }
  end

  context "comparison fails if location missing from either image" do
    let(:image_1) { create(:image, location: nil) }
    let(:image_2) { create(:image, location: nil) }
    let(:image) { create(:image) }

    subject(:image_imatches_1) do 
      expect(ImageTester).to_not receive(:compare)
      image_matches = ImageMatch.compare_images([image_1, image_2]) 
    end

    it { expect(image_imatches_1).to eq false }

    subject(:image_imatches_2) do 
      expect(ImageTester).to_not receive(:compare)
      image_matches = ImageMatch.compare_images([image_1, image]) 
    end

    it { expect(image_imatches_2).to eq false }

    subject(:image_imatches_3) do 
      expect(ImageTester).to_not receive(:compare)
      image_matches = ImageMatch.compare_images([image, image_2]) 
    end

    it { expect(image_imatches_3).to eq false }
  end
end