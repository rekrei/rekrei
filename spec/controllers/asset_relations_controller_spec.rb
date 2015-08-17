require 'rails_helper'

describe AssetRelationsController do

  context 'guest' do
    describe 'attempts to upload a picture' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }

      it 'should redirect when not logged in' do
        post :create, reconstruction_id: reconstruction.slug, asset_id: asset.id
        expect(response.code).to eq("302")
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'user' do
    login_user

    describe 'create with reconstruction' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }

      subject(:post_reconstruction_asset) { -> { post :create, reconstruction_id: reconstruction.slug, asset_id: asset.id } }

      it { is_expected.to change(AssetRelation, :count).by(1) }
    end

    describe 'remove image from reconstruciton' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }
      let!(:asset_relation) { create(:asset_relation, :with_reconstruction, reconstruction: reconstruction, asset: asset) }

      subject(:delete_reconstruction_asset) { -> { delete :destroy, id: asset_relation.id } }

      it { is_expected.to change(AssetRelation, :count).by(-1) }
    end
  end

  context 'admin' do
    login_admin

    describe 'without reconstruction' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }

      subject(:post_reconstruction_asset) { -> { post :create, reconstruction_id: reconstruction.slug, asset_id: asset.id } }

      it { is_expected.to change(AssetRelation, :count).by(1) }
    end

    describe 'remove image from reconstruciton' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }
      let!(:asset_relation) { create(:asset_relation, :with_reconstruction, reconstruction: reconstruction, asset: asset) }

      subject(:delete_reconstruction_asset) { -> { delete :destroy, id: asset_relation.id } }

      it { is_expected.to change(AssetRelation, :count).by(-1) }
    end
  end

end
