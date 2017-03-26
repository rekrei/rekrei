require 'rails_helper'

describe Reconstruction do
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should belong_to(:cover_image) }
  it { should belong_to(:location) }

  describe '.set_cover_image' do
    let(:image) { create(:image) }
    let(:reconstruction) { create(:reconstruction, :with_cover_image) }

    it 'should update cover image' do
      reconstruction.set_cover_image(image)
      reconstruction.reload
      expect(reconstruction.cover_image).to eq image
    end
  end

  describe 'asset relations' do
    let!(:image) { create(:image) }
    let!(:reconstruction) { create(:reconstruction) }
    let!(:asset_relation) do
      create(:asset_relation, asset: image, reconstruction: reconstruction)
    end

    it 'should only allow unique asset relations' do
      expect do
        AssetRelation.create(reconstruction: reconstruction, asset: image)
      end.to_not change(AssetRelation, :count)
    end
  end
end
