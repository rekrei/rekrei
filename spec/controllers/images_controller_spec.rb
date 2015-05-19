require 'rails_helper'

RSpec.describe ImagesController do
  context "Images Controller Creates Images" do
    def post_image
      post :create, image: attributes_for(:image) 
    end

    it "should post image" do
      expect { 
        post_image
      }.to change(Image, :count).by(1)
    end
  end
end
