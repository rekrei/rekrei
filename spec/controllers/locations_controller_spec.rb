require 'rails_helper'

describe LocationsController do

  context 'guest' do
  end

  describe 'user' do
    login_user

    describe 'with reconstruction' do
      let(:post_location) { post :create, location: attributes_for(:location) }

      it { expect{ post_location }.to change(Location, :count).by(1) }
    end
  end

  context 'admin' do
  end

end