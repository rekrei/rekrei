require 'rails_helper'

describe Api::V1::ImagesController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe 'get /images' do
    render_views
    def get_images
      FactoryGirl.create_list :image, 3
      get :index, format: :json
    end

    it "returns the information about a reporter on a hash" do
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
      @image = FactoryGirl.create :image
      get :show, id: @image.uuid, format: :json
      @image_response = JSON.parse(response.body, symbolize_names: true)
    end

    def get_image_with_artefact
      @image_with_artefact = FactoryGirl.create :image, :with_artefact
      @artefact = @image_with_artefact.artefact
      get :show, id: @image_with_artefact.uuid, format: :json
      @image_with_artefact_response = JSON.parse(response.body, symbolize_names: true)
    end

    it "should respond with 200" do
      get_image
      expect(response).to be_success
    end

    it "should assign id" do
      get_image
      expect(@image_response[:uuid]).to eq @image.uuid
    end

    it 'should assign url' do
      get_image
      expect(@image_response[:url]).to match "http://test.host/system/images/images/000/000/#{"%03d" % @image.id}/original/test1500white.png?"
    end

    context 'it should assign image.artefact even when empty' do
      before(:each) do
        get_image
      end
      it 'should assign an artefact even when empty' do
        expect(@image_response[:artefact].class).to eq Hash
      end

      it 'should assign an artefact even when empty' do
        expect(@image_response[:artefact][:id]).to be_nil
      end
    end

    context 'it should assign image.artefact when associated' do
      before(:each) do
        get_image_with_artefact
      end

      it 'should assign artefact id' do
        expect(@image_with_artefact_response[:artefact][:id]).to eq @artefact.id
      end

      it 'should assign artefact uuid' do
        expect(@image_with_artefact_response[:artefact][:uuid]).to eq @artefact.uuid
      end

      it 'should assign artefact name' do
        expect(@image_with_artefact_response[:artefact][:name]).to eq @artefact.name
      end

      it 'should assign artefact uri' do
        expect(@image_with_artefact_response[:artefact][:uri]).to eq "/artefacts/#{@artefact.uuid}"
      end
    end
  end
end