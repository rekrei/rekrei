require 'rails_helper'

describe AssetRelationsController do
  context 'guest' do
    describe 'cannot create a new asset relation if not logged in' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }

      subject { -> { post :create, reconstruction_id: reconstruction.slug, asset_id: asset.id } }
      it { is_expected.to change(AssetRelation, :count).by(0) }
    end

    describe 'will be redirect to sign in path if not logged in' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }

      subject { post :create, reconstruction_id: reconstruction.slug, asset_id: asset.id }
      it { expect(subject).to redirect_to new_user_session_path }
    end

    describe 'cannot create a new asset relation if not logged in (JSON)' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }

      subject { -> { post :create, reconstruction_id: reconstruction.slug, asset_id: asset.id, format: :json } }
      it { is_expected.to change(AssetRelation, :count).by(0) }
    end

    describe 'will be redirect to sign in path if not logged in (JSON)' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }

      it 'should return a 401 error with JSON' do
        post :create, reconstruction_id: reconstruction.slug, asset_id: asset.id, format: :json
        expect(response.status).to eq 401
        expect(response.body).to eq({ error: 'Authentication failure!' }.to_json)
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

    describe 'create with reconstruction (JSON)' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }

      subject(:post_reconstruction_asset) { -> { post :create, reconstruction_id: reconstruction.slug, asset_id: asset.id, format: :json } }

      it { is_expected.to change(AssetRelation, :count).by(1) }
    end

    describe 'creating reconstruction should see (JSON)' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }

      it 'asset id and asset relation id' do
        post :create, reconstruction_id: reconstruction.slug, asset_id: asset.id, format: :json
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['message']).to eq 'success'
        expect(JSON.parse(response.body)['asset_id']).to eq asset.id
        expect(JSON.parse(response.body)['asset_relation_id']).to eq assigns(:asset_relation).id
      end
    end

    describe 'remove image from reconstruciton' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }
      let!(:asset_relation) { create(:asset_relation, :with_reconstruction, reconstruction: reconstruction, asset: asset) }

      subject(:delete_reconstruction_asset) { -> { delete :destroy, id: asset_relation.id } }

      it { is_expected.to change(AssetRelation, :count).by(-1) }
    end

    describe 'remove (JSON)' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }
      let!(:asset_relation) { create(:asset_relation, :with_reconstruction, reconstruction: reconstruction, asset: asset) }

      subject(:delete_reconstruction_asset) { -> { delete :destroy, id: asset_relation.id, format: :json } }

      it { is_expected.to change(AssetRelation, :count).by(-1) }
    end

    describe 'creating reconstruction should see (JSON)' do
      let!(:reconstruction) { create(:reconstruction) }
      let!(:asset) { create(:image) }
      let!(:asset_relation) { create(:asset_relation, :with_reconstruction, reconstruction: reconstruction, asset: asset) }

      it 'asset id and asset relation id' do
        delete :destroy, id: asset_relation.id, format: :json
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['message']).to eq 'success'
        expect(JSON.parse(response.body)['asset_relation_id']).to eq assigns(:asset_relation).id
      end
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
