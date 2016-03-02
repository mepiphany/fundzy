require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  let(:user) {FactoryGirl.create(:user)}

  context "with valid credentials" do
    it "redirects to the home page / show the user full name / displays text 'Signed In'" do
      visit new_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password

      click_button "Sign In"

      user_full_name = "#{user.first_name} #{user.last_name}"

      expect(current_path).to eq (root_path)
      expect(page).to have_text /#{user_full_name}/i
      expect(page).to have_text /Signed In/i


    end
  end
  context "with invalid credentials" do
    it "doens't show the user full name and it displays `Wrong Credentials`" do
      visit new_session_path

      fill_in "Email", with: "bad+#{user.email}"
      fill_in "Password", with: "bad+#{user.password}"
      click_button "Sign In"

      expect(current_path).to eq(sessions_path)
      expect(page).to have_text /Wrong Credentials/i
      expect(page).to_not have_text /#{user.full_name}/i
    end
  end
end
