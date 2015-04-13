#spec/requests/api/v1/images_spec.rb
require 'rails_helper'

describe "Images API" do  describe '#index' do
    it 'sends a list of images' do
      FactoryGirl.create_list(:image, 10)

      get '/api/v1/images'

      expect(response).to be_success
      json = JSON.parse(response.body)
      expect(json.length).to eq(10)
    end
  end

  describe '#show' do
    let(:image) { FactoryGirl.create(:image) }  
    
    it 'gets a specific image' do

      get "/api/v1/images/#{image.id}"
      expect(response).to be_success
      json = JSON.parse(response.body)
      expect(json["id"]).to eq image.id
    end
  end
end