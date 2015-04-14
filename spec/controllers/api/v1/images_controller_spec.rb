require 'rails_helper'

describe Api::V1::ImagesController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe 'get #index' do
    def get_images
      @image = FactoryGirl.create_list :image, 3
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
end