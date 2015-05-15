require 'rails_helper'

describe Image do
  it { should have_many(:parent_matches) }
  it { should have_many(:comparison_matches) }

  describe 'images related to reconstruction' do
    let(:image) { create(:image) }
    let(:image_belonging_to_reconstruction) { create(:image, :with_reconstruction) }

    it '.assigned_to_reconstruction' do
      expect(Image.location(image_belonging_to_reconstruction.location).assigned_to_reconstruction).to eq([image_belonging_to_reconstruction])
    end

    it '.unassigned_to_reconstruction' do
      expect(Image.location(image.location).unassigned_to_reconstruction).to eq([image])
    end

    it '.all' do
      expect(Image.all).to include(image)
      expect(Image.all).to include(image_belonging_to_reconstruction)
    end
  end

  context 'scopes' do
    let(:location_1) { create(:location) }
    let(:location_2) { create(:location) }
    let!(:images_1) { create_list(:image, 5, location: location_1) }
    let!(:images_2) { create_list(:image, 5, location: location_2) }

    it { expect(images_1.collect(&:location).uniq.first).to eq(location_1) }
    it { expect(Image.location(location_1).count).to eq 5 }
  end

  describe 'find next unassigned image' do
    let!(:location) { create(:location) }
    let!(:image_1) { create(:image, location: location) }
    let!(:image_2) { create(:image, location: location) }
    let!(:image_3) { create(:image, location: location) }
    let!(:image_4) { create(:image, :with_reconstruction, location: location) }

    it 'Image.next image_1' do
      expect(Image.next(image_1)).to eq(image_2)
    end

    it 'Image.previous image_3' do
      expect(Image.previous(image_3)).to eq(image_2)
    end

    it 'image_1.next' do
      expect(image_1.next).to eq(image_2)
    end

    it 'image_2.next' do
      expect(image_2.next).to eq(image_3)
    end

    it 'image_3.next' do
      expect(image_3.next).to be_nil
    end

    it 'image_3.previous' do
      expect(image_3.previous).to eq(image_2)
    end

    it 'image_2.previous' do
      expect(image_2.previous).to eq(image_1)
    end

    it 'image_1.previous' do
      expect(image_1.previous).to be_nil
    end
  end

  describe 'image unmatch scopes' do
    let!(:location) { create(:location) }
    let!(:parent_image) { create(:image, location: location) }
    let!(:comparison_image) { create(:image, location: location) }
    let!(:image_match_1){ create(:image_match, parent_image: parent_image, comparison_image: comparison_image, location: location) }
    let!(:image_match_2){ create(:image_match, parent_image: comparison_image, comparison_image: parent_image, location: location) }    
    let!(:new_image){ create(:image, location: location) }
    let!(:new_image_from_another_location){ create(:image) }

    # the two image matches above will create two images each
    it { expect(Image.count).to eq(4) }
    it { expect(ImageMatch.count).to eq(2) }
    it { expect(Image.parent_match_images.count).to eq(2) } 
    it { expect(Image.comparison_match_images.count).to eq(2) } 
    it { expect(Image.matched.count).to eq(2) }
    it { expect(Image.unmatched.count).to eq(2) }

    # find images that haven't been matched against another
    it { expect(new_image.unmatched_images.count).to eq 2 }
    it { expect(new_image.unmatched_images).to include(parent_image) }
    it { expect(new_image.unmatched_images).to include(comparison_image) }
  end

  describe 'image matches scopes' do
    let!(:location_1) { create(:location) }
    let!(:location_2) { create(:location) }
    let!(:image_1) { create(:image, location: location_1) }
    let!(:image_2) { create(:image, location: location_1) }
    let!(:image_3) { create(:image, location: location_1) }
    let!(:image_4) { create(:image, location: location_1) }
    let!(:image_5) { create(:image, location: location_1) }
    let!(:image_6) { create(:image, location: location_1) }
    let!(:image_7) { create(:image, location: location_2) }
    let!(:image_match_1) { create(:image_match, matches: 900, parent_image: image_1, comparison_image: image_2, location: location_1) }
    let!(:image_match_2) { create(:image_match, matches: 700, parent_image: image_1, comparison_image: image_4, location: location_1) }
    let!(:image_match_3) { create(:image_match, matches: 800, parent_image: image_1, comparison_image: image_3, location: location_1) }
    let!(:image_match_4) { create(:image_match, matches: 600, parent_image: image_1, comparison_image: image_5, location: location_1) }
    let!(:image_match_5) { create(:image_match, matches: 500, parent_image: image_1, comparison_image: image_6, location: location_1) }
    let!(:image_match_6) { create(:image_match, matches: 500, parent_image: image_1, comparison_image: image_6, location: location_2) }

    it { expect(ImageMatch.count).to eq 6 }
    it { expect(Image.count).to eq 7 }
    it { expect(image_1.compared_images.count).to eq 5 }
    it { expect(image_1.compared_images).to eq([image_2, image_3, image_4, image_5, image_6])}
  end

  describe 'compare' do
    let(:location) { create(:location) }
    let(:image_1) { create(:image, location: location) }
    let(:image_2) { create(:image, location: location) }
    let!(:existing_image) { create(:image, location: location) }
    let(:new_image) { build(:image, location: location) }

    it "should create two new table entries upon comparison" do
      expect {
        allow(ImageTester).to receive(:compare).and_return({:matches=>1000, :error=>false, :time=>0.201})
        image_1.compare(image_2)
      }.to change(ImageMatch, :count).by(2)
    end

    it "should create image matches after creating" do
      expect {
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 1
        new_image.save
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(1)
    end
  end
end
