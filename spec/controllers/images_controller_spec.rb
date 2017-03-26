require 'rails_helper'

describe ImagesController do
  context 'guest' do
    describe 'attempts to upload a picture' do
      let!(:location) { create(:location) }

      it 'should redirect when not logged in' do
        post :create, location_id: location.slug, image: attributes_for(:image, :with_stubbed_image)
        expect(response.code).to eq('302')
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'all images' do
      let!(:location) { create(:location) }
      let!(:images_with_reconstruction) { create_list(:image, 2, :with_stubbed_image, :with_reconstruction, location: location) }
      let!(:image_with_reconstruction) { create(:image, :with_stubbed_image, :with_reconstruction, location: location) }
      let!(:images_without_reconstruction) { create_list(:image, 2, :with_stubbed_image, location: location) }

      it 'get unassigned images' do
        get :index, location_id: location.id
        expect(assigns(:images).count).to eq 2
        expect(assigns(:images)).to include(images_without_reconstruction.first)
        expect(assigns(:images)).to include(images_without_reconstruction.last)
      end

      it 'get all images' do
        get :index, location_id: location.id, show: 'all'
        expect(assigns(:images).count).to eq 5
        expect(assigns(:images)).to include(images_without_reconstruction.first)
        expect(assigns(:images)).to include(images_without_reconstruction.last)
        expect(assigns(:images)).to include(images_with_reconstruction.first)
        expect(assigns(:images)).to include(images_with_reconstruction.last)
      end

      it 'get all images except for ones included in a reconstruction' do
        get :index, location_id: location.id, show: 'all', reconstruction_slug: image_with_reconstruction.reconstructions.first.slug
        expect(assigns(:images).count).to eq 4
        expect(assigns(:images)).to include(images_without_reconstruction.first)
        expect(assigns(:images)).to include(images_without_reconstruction.last)
        expect(assigns(:images)).to include(images_with_reconstruction.first)
        expect(assigns(:images)).to include(images_with_reconstruction.last)
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

    describe 'all images' do
      let!(:location) { create(:location) }
      let!(:images_with_reconstruction) { create_list(:image, 2, :with_stubbed_image, :with_reconstruction, location: location) }
      let!(:images_without_reconstruction) { create_list(:image, 2, :with_stubbed_image, location: location) }

      it 'get unassigned images' do
        get :index, location_id: location.id
        expect(assigns(:images).count).to eq 2
        expect(assigns(:images)).to include(images_without_reconstruction.first)
        expect(assigns(:images)).to include(images_without_reconstruction.last)
      end

      it 'get all images' do
        get :index, location_id: location.id, show: 'all'
        expect(assigns(:images).count).to eq 4
        expect(assigns(:images)).to include(images_without_reconstruction.first)
        expect(assigns(:images)).to include(images_without_reconstruction.last)
        expect(assigns(:images)).to include(images_with_reconstruction.first)
        expect(assigns(:images)).to include(images_with_reconstruction.last)
      end
    end
  end

  context 'admin' do
  end
end
