require 'rails_helper'

describe Image do
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

  describe 'compare' do
    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }

    it "should create two new table entries upon comparison" do
      expect {
        image_1.compare(image_2)
      }.to change(ImageMatch, :count).by(2)
    end
  end
end
