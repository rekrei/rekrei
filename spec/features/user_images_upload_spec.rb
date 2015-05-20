require 'rails_helper'

describe 'User Uploads Image' do
  login_as FactoryGirl.create(:user)
  let(:location) { create(:location) }
  let(:reconstruction) { create(:reconstruction, location: location) }

  it "can upload images" do
    expect {
      visit location_path(location)
      attach_file('image_image',
                  Rails.root.join('spec',
                                  'fixtures',
                                  'files',
                                  'test1500white.png'), 
                  visible: false)
    }.to change(Image, :count).by(1)
  end
end