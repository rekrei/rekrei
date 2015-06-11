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
  end

  context 'admin' do
  end

end
