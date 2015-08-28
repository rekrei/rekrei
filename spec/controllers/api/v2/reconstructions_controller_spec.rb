require 'rails_helper'

describe Api::V2::ReconstructionsController do
  before(:each) { request.headers['Accept'] = "application/vnd.projectmosul.v2" }

  describe 'get /reconstructions' do
    def get_reconstructions
      FactoryGirl.create_list :reconstruction, 3
      get :index, format: :json
    end

    it "returns the information about a reporter on a hash" do
      get_reconstructions
      reconstructions_response = JSON.parse(response.body, symbolize_names: true)
      expect(reconstructions_response.count).to eql 3
    end

    it 'should respond with 200' do
      get_reconstructions
      expect(response).to be_success
    end
  end
end
