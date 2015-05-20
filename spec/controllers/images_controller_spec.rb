require 'rails_helper'

RSpec.describe ImagesController do
  context "Images Controller Creates Images" do
    let!(:location) { create(:location) }
    let!(:reconstruction) { create(:reconstruction) }
    
    login_as FactoryGirl.create(:user)

    def post_image
      post :create, location_id: location.slug, image: attributes_for(:image), reconstruction_id: reconstruction.id
    end



    it "should post image" do
      expect { 
        post_image
      }.to change(Image, :count).by(1)
    end
  end
end
