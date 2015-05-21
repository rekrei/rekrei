require 'rails_helper'

describe ImagesController do
  
  context 'guest' do
  end

  context 'user' do
    login_as FactoryGirl.create(:user)

    context 'with reconstruction' do
      let(:location) { create(:location) }
      let(:reconstruction) { create(:reconstruction) }

      subject(:post_image) { -> { post :create, location_id: location.id, reconstruction_id: reconstruction.id, image: {image: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test1500white.png'), 'image/png') } } }

      it { is_expected.to change(Image, :count).by(1) }
      it { is_expected.to change(AssetRelation, :count).by(1) }
    end
  end

  context 'admin' do
  end

end