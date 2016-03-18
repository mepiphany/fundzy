class DetermineCampaignStateJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    campaign = args[0]
    pledges_amount = campaign.pledges.sum(:amount)
    if pledges_amount >= campaign.goal
      campaign.fund!
    else
      campaign.unfund!
    end
  end
end
