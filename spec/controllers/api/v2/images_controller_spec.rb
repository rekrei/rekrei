require 'rails_helper'

describe Api::V2::ImagesController do
  before(:each) { request.headers['Accept'] = 'application/vnd.projectmosul.v2' }

  describe 'get /images' do
    render_views
    def get_images
      create_list :image, 3, :with_stubbed_image
      get :index, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      get_images
      image_response = JSON.parse(response.body, symbolize_names: true)
      expect(image_response[:images].count).to eql 3
    end

    it 'should respond with 200' do
      get_images
      expect(response).to be_success
    end
  end

  describe 'get images/:id' do
    render_views
    def get_image
      @image = create :image, :with_stubbed_image
      get :show, id: @image.uuid, format: :json
      @image_response = JSON.parse(response.body, symbolize_names: true)
    end

    def get_image_with_reconstruction
      @reconstruction = create :reconstruction
      @image = create :image, :with_stubbed_image
      @reconstruction.images << @image
      get :show, id: @image.uuid, format: :json
      @image_with_reconstruction_response = JSON.parse(response.body, symbolize_names: true)
    end

    it 'should respond with 200' do
      get_image
      expect(response).to be_success
    end

    it 'should assign id' do
      get_image
      expect(@image_response[:uuid]).to eq @image.uuid
    end

    it 'should assign url' do
      get_image
      expect(@image_response[:url]).to match /http:\/\/test.host\/system\/images\/images\/\d{3}\/\d{3}\/\d{3}\/original\/test1500white.png/
    end

    context 'it should assign image.location' do
      before(:each) do
        get_image
      end

      it 'should assign an artefact even when empty' do
        expect(@image_response[:location]).to eq @image.location.uuid
      end
    end

    context 'it should assign image.reconstruction when associated' do
      before(:each) do
        get_image_with_reconstruction
      end

      it 'should assign reconstructions id' do
        expect(@image_with_reconstruction_response[:reconstructions]).to eq [@reconstruction.uuid]
      end
    end
  end
end
