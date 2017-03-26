require 'rails_helper'

describe Api::V2::LocationsController do
  before(:each) { request.headers['Accept'] = 'application/vnd.projectmosul.v2' }

  describe 'get /reconstructions' do
    render_views
    def get_locations
      FactoryGirl.create_list :location, 3
      get :index, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      get_locations
      locations_response = JSON.parse(response.body, symbolize_names: true)
      expect(locations_response[:locations].count).to eql 3
    end

    it 'should respond with 200' do
      get_locations
      expect(response).to be_success
    end
  end
end
