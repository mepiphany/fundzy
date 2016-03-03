class PledgesController < ApplicationController
  before_action :authenticate_user

  def create
    @campaign = Campaign.friendly.find params[:campaign_id]
    @pledge = Pledge.new pledge_params
    @pledge.campaign = @campaign
    @pledge.user = current_user
    @pledge.save
    render nothing: true

  end

  def destroy
    pledge   = current_user.pledges.find params[:id]
    campaign = Campaign.friendly.find params[:campaign_id]

    pledge.destroy
    redirect_to campaign
  end



  private

  def pledge_params
    params.require(:pledge).permit(:amount)
  end



end
