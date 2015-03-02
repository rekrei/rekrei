require "rails_helper"

feature "Guest wants to upload image" do
  scenario "and is presented with a login or signup page" do
    visit artefacts_path
    page.should have_selector('div#erro_div')
    # expect(response).to redirect_to root_path
  end
end