require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe "validations" do
    # every test scenario must be put with in an 'it' or 'specify' block.
    # it is a method that takes a test example description and a block of code
    # wehre you can construct your test.

    it "doesn't allow creating a campaign with no name" do
      # GIVEN: campaign with no title
      c = Campaign.new
      # WHEN: we validate the campaign
      campaign_valid = c.valid?
      # THEN: expect that compaign_valid should be false
      expect(campaign_valid).to eq(false)
      # expecting campaign_valid to == false
    end

    it "requires a goal" do
      # GIVEN:
      c = Campaign.new
      # WHEN:
      c.valid?
      # THEN:
      expect(c.errors).to have_key(:goal)
      # we call method like: have_key matchers
      # RSpec and RSpec Rails come with may built-in matchers
    end

    it "requires a goal that is more than 10" do
    # GIVEN:
    c = Campaign.new(goal: 6)
    # WHEN:
    c.valid?
    # THEN:
    expect(c.errors).to have_key(:goal)
    end

    it "requires a unique title" do
    # GIVEN:
    Campaign.create({name: "anything", goal: 100, description: "abc"})
    c = Campaign.new(name: "anything")
    # WHEN:
    c.valid?
    # THEN:
    expect(c.errors).to have_key(:name)
    end



end
end
