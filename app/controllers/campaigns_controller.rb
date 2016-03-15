class CampaignsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  REWARD_COUNT = 3
  def new
     @campaign = Campaign.new
     REWARD_COUNT.times { @campaign.rewards.build }

  end

  def create
    campaign_params = params.require(:campaign).permit(:name, :goal, :description, :end_date, :image, {rewards_attributes: [:amount, :title, :id, :_destroy]})
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user

  # this sends a successful empty HTTP response (200)
    flash[:notice] = "Campaign Created!"
    if @campaign.save
    redirect_to campaign_path(@campaign)
   else
    build_associated_rewards
    flash[:alert] = "campaign not created"
    render :new
  end
 end

 def show
   @campaign = Campaign.friendly.find params[:id]
   #find_by method will return nil, but in find, it will raise an error
   # The default render is show
   #  render :show
 end

 def index
   @campaigns = Campaign.all

 end

 def edit
   @campaign = Campaign.friendly.find params[:id]
   build_associated_rewards

 end

 def update
   # we need to force the slug to be nil before updating it in order to have
   # FriendlyId generate a new slug for us. We're using `history` option with
   # FriendlyId so old urls will still work.
  #  @campaign.slug = nil
   @campaign = Campaign.friendly.find params[:id]
   campaign_params = params.require(:campaign).permit(:name, :description, :goal, :end_date, {rewards_attributes: [:amount, :title, :id, :_destroy]})
   if @campaign.update (campaign_params)
   redirect_to campaign_path(@campaign), notice: "campaign"
 else
   flash[:alert] = "failed "
   render :edit
 end
end

def destroy
  campaign = current_user.campaigns.friendly.find params[:id]
  campaign.destroy
  redirect_to root_path, alert: "destroyed"
end

private

def build_associated_rewards
  number_to_build = REWARD_COUNT - @campaign.rewards.size
  number_to_build.times { @campaign.rewards.build }
end


end
