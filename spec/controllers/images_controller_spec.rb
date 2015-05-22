require 'rails_helper'

describe ImagesController do

  context 'guest' do
    describe 'attempts to upload a picture' do
      let!(:location) { create(:location) }

      it 'should redirect when not logged in' do
        post :create, location_id: location.slug, image: attributes_for(:image, :with_stubbed_image)
        expect(response.code).to eq("302")
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'user' do
    login_user
    
    describe 'without reconstruction' do
      let!(:location) { create(:location) }

      subject(:post_image) { -> { post :create, location_id: location.slug, image: attributes_for(:image, :with_stubbed_image) } }

      it { is_expected.to change(Image, :count).by 1 }
      it { is_expected.to_not change(AssetRelation, :count) }
    end

    describe 'with reconstruction' do
      let!(:location) { create(:location) }
      let!(:reconstruction) { create(:reconstruction) }

      subject(:post_image) { -> { post :create, location_id: location.slug, reconstruction_id: reconstruction.id, image: attributes_for(:image, :with_stubbed_image) } }

      it { is_expected.to change(Image, :count).by 1 }
      it { is_expected.to change(AssetRelation, :count).by(1) }
      it { is_expected.to change(reconstruction.images, :count).by(1) }
    end
  end

  context 'admin' do
  end

end