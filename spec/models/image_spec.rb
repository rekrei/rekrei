require 'rails_helper'

describe Image do
  describe 'images related to artefacts' do
    let(:image) { create(:image) }
    let(:image_belonging_to_artefact) { create(:image, :with_artefact) }

    it '.assigned_to_artefact' do
      expect(Image.assigned_to_artefact).to eq([image_belonging_to_artefact])
    end

    it '.unassigned_to_artefact' do
      expect(Image.unassigned_to_artefact).to eq([image])
    end

    it '.all' do
      expect(Image.all).to include(image)
      expect(Image.all).to include(image_belonging_to_artefact)
    end
  end

  describe 'find next unassigned image' do
    let!(:image_1) { create(:image) }
    let!(:image_2) { create(:image) }
    let!(:image_3) { create(:image) }
    let!(:image_4) { create(:image, :with_artefact) }

    it 'Image.next image_1' do
      expect(Image.next(image_1)).to eq(image_2)
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
end
