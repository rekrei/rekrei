require 'rails_helper'

describe Api::V1::ArtefactsController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe 'get /artefacts' do
    def get_artefacts
      FactoryGirl.create_list :artefact, 3
      get :index, format: :json
    end

    it "returns the information about a reporter on a hash" do
      get_artefacts
      artefacts_response = JSON.parse(response.body, symbolize_names: true)
      expect(artefacts_response.count).to eql 3
    end

    it 'should respond with 200' do
      get_artefacts
      expect(response).to be_success
    end
  end
end
