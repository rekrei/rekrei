require 'rails_helper'

describe Api::V1::ImagesController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe 'get /images' do
    def get_images
      FactoryGirl.create_list :image, 3
      get :index, format: :json
    end

    it "returns the information about a reporter on a hash" do
      get_images
      image_response = JSON.parse(response.body, symbolize_names: true)
      expect(image_response.count).to eql 3
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
      get :show, id: @image.id, format: :json
      @image_response = JSON.parse(response.body, symbolize_names: true)
    end

    it "should respond with 200" do
      get_image
      expect(response).to be_success
    end

    it "should assign id" do
      get_image
      expect(@image_response[:id]).to eq @image.id
    end

    it 'should assign url' do
      get_image
      expect(@image_response[:url]).to contain "http://test.host/system/images/images/000/000/#{@image.id}/original/test1500white.png?"
    end
  end
end