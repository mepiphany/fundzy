class CampaignsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  def new
     @campaign = Campaign.new
  end

  def create
    campaign_params = params.require(:campaign).permit(:name, :goal, :description, :end_date)
    @campaign = Campaign.create(campaign_params)
  # this sends a successful empty HTTP response (200)
    flash[:notice] = "Campaign Created!"
    if @campaign.save
    redirect_to campaign_path(@campaign)
   else
    flash[:alert] = "campaign not created"
    render :new
  end
 end

 def show
   @campaign = Campaign.find_by_id params[:id]
   #find_by method will return nil, but in find, it will raise an error
   # The default render is show
  #  render :show
 end

 def index
   @campaigns = Campaign.all

 end

 def edit
   @campaign = Campaign.find params[:id]

 end

 def update
   @campaign = Campaign.find params[:id]
   campaign_params = params.require(:campaign).permit(:name, :description, :goal, :end_date)
   if @campaign.update (campaign_params)
   redirect_to campaign_path(@campaign), notice: "campaign"
 else
   flash[:alert] = "failed "
   render :edit
 end
end

def destroy
  campaign = current_user.campaigns.find params[:id]
  campaign.destroy
  redirect_to root_path, alert: "destroyed"
end


end
