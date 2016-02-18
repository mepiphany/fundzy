FactoryGirl.define do
  factory :pledge do
    # this will automatically create a campaign record and associate the pledge
    # record with it, if you don't pass a comapign to the pledge factory
    association :campaign, factory: :campaign
    association :user,     factory: :user
    amount { 1 + rand(1000) }
  end
end
