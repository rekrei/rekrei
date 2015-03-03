require 'rails_helper'

describe "artefacts", :type=>:feature do
  scenario "guest attempts to create an artefact" do
    visit artefacts_path
    expect(page).to have_content "You must be signed in to create an artefact"
  end
end