require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "Validations" do
    it "requires a first_name" do
      # GIVEN: a new uesr object
      u = User.new
      # WHEN: Validating the record
      u.valid?
      # THEN: Should have errors on the 'first_name' attribute
      expect(u.errors).to have_key(:first_name)
    end
    it "requires an email" do
      # GIVEN: a new email object
      u = User.new
      # WHEN: Validating the record
      u.valid?
      # THEN: Should have errors on the "email" attribute
      expect(u.errors).to have_key(:email)
    end

    it "requires a password" do
      u = User.new
      u.valid?
      expect(u.errors).to have_key(:password)


    end
    it "requires a unique email" do
      # GIVEN:
      # user created with some valid email
      u = FactoryGirl.create(:user)
      # WHEN
      u1 = User.create email: u.email
      u1.valid?

      #THEN
      expect(u1.errors).to have_key(:email)
    end
end

  describe ".full_name" do
    it "concatenates the first name and last name" do
      u = FactoryGirl.build(:user) #try to use .build if you don't need to connect to the database
      expect(u.full_name).to include("#{u.first_name}", "#{u.last_name}")
    end
    it "returns the first name if the last name is missing" do
      u = FactoryGirl.build(:user, {last_name: nil})
      expect(u.full_name).to eq(u.first_name)

    end

  end

  describe "password generating" do
    it "generates a password digest on creation" do
      #GIVEN
      u = FactoryGirl.build(:user)
      expect(u.password_digest).to be
    end
end

end
