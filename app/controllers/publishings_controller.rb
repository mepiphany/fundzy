class PublishingsController < ApplicationController
  before_action :authenticate_user

  def create
    campaign = current_user.campaigns.friendly.find params[:campaign_id]
    service = Campaigns::PublishCampaign.new(campaign: campaign)

    if service.call
      redirect_to campaign, notice: "Published!"
    else
      redirect_to campaign, alert: "can't publish! Published alrady?"
    end
  end
end
