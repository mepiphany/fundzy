require 'rails_helper'

RSpec.feature "Campaigns", type: :feature do
  describe "Campaigns Listing" do
    it "displays a text 'Recent Campaigns'" do
      # this simulates users typing the 'campaigns_path' in the address bar
      #  to actually visit the page
      visit campaigns_path
      # we have access to an object 'page' that contains the rendered HTML page
      # we can use it with RSpec Matchers to perform tests
      expect(page).to have_text "Recent Campaigns"
    end

    it "desplays an h2 header with text 'All Campaigns'" do
      visit campaigns_path
      expect(page).to have_selector "h2", text: "All Campaigns"
    end

    it "has a page title of 'Welcome to fund.sy'" do
      visit campaigns_path
      expect(page).to have_title "Welcome to fund.sy"
    end

    it "displays a campaign's name" do
      campaign = FactoryGirl.create(:campaign)
      visit campaigns_path
      # This will open a web page with the current state
      # save_and_open_page
      expect(page).to have_text /#{campaign.name}/i # i means case insensitive
    end
  end
end
