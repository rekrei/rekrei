#spec/requests/api/v1/images_spec.rb
require 'rails_helper'

describe "Images API" do  
  it 'sends a list of images' do
    FactoryGirl.create_list(:image, 10)

    get '/api/v1/images'

    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json['images'].length).to eq(10)
  end
end