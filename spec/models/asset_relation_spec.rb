require 'rails_helper'

RSpec.describe AssetRelation, type: :model do
  it { should belong_to(:asset) }
  it { should belong_to(:relatable) }

  context "polymorphic relationships" do
    let(:asset_relation_reconstruction) { build_stubbed(:asset_relation, :with_reconstruction) }
    let(:asset_relation_location) { build_stubbed(:asset_relation, :with_location) }

    it { expect(asset_relation_reconstruction.relatable).to be_an_instance_of Reconstruction }
    it { expect(asset_relation_location.relatable).to be_an_instance_of Location }
  end

  context "location has images through image relations" do 
    let(:location) { create(:location) }
    let(:asset_relation) { create(:asset_relation, relatable: location) }

    it { expect(location.images).to eq([asset_relation.asset]) }
  end

  context "reconstruction has images through image relations" do 
    let(:reconstruction) { create(:reconstruction) }
    let(:asset_relation) { create(:asset_relation, relatable: reconstruction) }

    it { expect(reconstruction.images).to eq([asset_relation.asset]) }
  end

  context "migrating to the new many-to-many relationship [location]" do
    let!(:location) { create(:location) }
    let!(:image) { create(:image, location_id: location.id) }

    it "should migrate from locations to image relations" do
      expect(location.images).to eq([])
      expect {
        AssetRelation.migrate_to_many_to_many
      }.to change(AssetRelation, :count).by(1)
      expect(location.reload.images).to eq([image])
    end
  end

  context "migrating to the new many-to-many relationship [reconstruction]" do
    let!(:reconstruction) { create(:reconstruction) }
    let!(:image) { create(:image, reconstruction_id: reconstruction.id, location: nil) }

    it "should migrate from locations to image relations" do
      expect(reconstruction.images).to eq([])
      expect {
        AssetRelation.migrate_to_many_to_many
      }.to change(AssetRelation, :count).by(1)
      expect(reconstruction.reload.images).to eq([image])
    end
  end
end
