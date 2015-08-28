require 'rails_helper'

describe ReconstructionsController do

  context 'guest' do
  end

  describe 'user' do
    login_user

    describe 'with location' do
      let!(:image) { create(:image) }
      let(:location) { create(:location) }
      let(:post_reconstruction) { post :create, location_id: location.slug, reconstruction: attributes_for(:reconstruction, location: location).merge(cover_image_id: image.id) }

      it { expect{ post_reconstruction }.to change(Reconstruction, :count).by(1) }
    end

    describe 'edit a reconstruction' do
      render_views
      let(:reconstruction) { create(:reconstruction, :with_cover_image) }

      it "assigns @image" do
        get :edit, id: reconstruction.slug, location_id: reconstruction.location.slug
        expect(assigns(:image)).to eq(reconstruction.cover_image)
      end

      it 'renders template' do
        get :edit, id: reconstruction.slug, location_id: reconstruction.location.slug
        expect(response).to render_template('edit')
      end
    end
  end

  context 'admin' do
  end

end
