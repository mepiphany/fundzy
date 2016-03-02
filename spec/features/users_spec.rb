require 'rails_helper'

RSpec.feature "Users", type: :feature do


  describe "sign up" do
    context "with correct information" do
      it "redirects to the home page / display the user name on the page /
          displays 'Account Created!' Message" do
        visit new_user_path
        valid_user_attributes = FactoryGirl.attributes_for(:user)
        # you can fill in information in the field
        fill_in "First name", with: valid_user_attributes[:first_name]
        fill_in "Last name", with: valid_user_attributes[:last_name]
        fill_in "Email", with: valid_user_attributes[:email]
        fill_in "Password", with: valid_user_attributes[:password]
        fill_in "Password confirmation", with: valid_user_attributes[:password]

        click_button "Sign Up"

        user_full_name = "#{valid_user_attributes[:first_name]} #{valid_user_attributes[:last_name]}"

        expect(current_path).to eq(root_path)

        expect(page).to have_text /#{user_full_name}/i
        expect(page).to have_text /Account Created!/i
      end
    end

    context "with incalid information" do
      it "alert the user with 'Fail' and it doesn't show the user's name" do
        visit new_user_path
        fill_in "user_first_name", with: "John"
        click_button "Sign Up"

        expect(page).to have_text /fail/i
        expect(page).to_not have_text /john/i

      end




    end


  end

end
