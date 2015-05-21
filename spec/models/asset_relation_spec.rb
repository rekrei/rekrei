require 'rails_helper'

RSpec.describe AssetRelation, type: :model do
  it { should belong_to(:asset) }
  it { should belong_to(:reconstruction) }

  context "migrating to the new many-to-many relationship [reconstruction]" do
    let!(:location) { create(:location) }
    let!(:reconstruction) { create(:reconstruction) }
    let!(:image) { create(:image, reconstruction_id: reconstruction.id, location: location) }

    it "should migrate from locations to image relations" do
      expect(reconstruction.images).to eq([])
      expect {
        AssetRelation.migrate_to_many_to_many
      }.to change(AssetRelation, :count).by(1)
      expect(reconstruction.reload.images).to eq([image])
    end
  end
end
