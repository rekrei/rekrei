require 'rails_helper'

describe 'images', type: :feature do
  scenario 'guest attempts to create an image' do
    visit images_path
    expect(page).to have_content 'You must be signed in to upload images'
  end

  scenario 'logged in user visits artefact page' do
    user = create(:user)
    login_as user
    visit images_path
    expect(page).to have_no_content 'Drop files here to upload'
  end
end
