require 'rails_helper'

feature "Admin dashboard" do
  scenario "visitor is admin" do
    admin = create(:user, :admin)
    login_as admin
    visit rails_admin_path(as: admin)

    expect(page).to have_content("Site Administration")
  end

  scenario "visitor is not an admin user" do
    user = create(:user)
    login_as user
    visit rails_admin_path

    expect(page).to have_content("You are not permitted to view this page")
  end
end