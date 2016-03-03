require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do

  # Both are exactly the same thing
  let(:user) { FactoryGirl.create(:user) }
  let(:campaign) { FactoryGirl.create(:campaign, {user: user}) }
  let(:campaign_1) { FactoryGirl.create(:campaign) }
                    #==
  # def campaign
  #   @campaign ||= FactoryGirl.create(:campaign)
  # end

  describe "#new" do
    before { signin(user) }
    it "renders the new template" do
      # This mimics seding a get request to the new action
      get :new
      # response is an object that is given to us by RSpec that will help test
      # things like redirect / render
      # render_template is a an RSpec (rspec-rails) matcher that help us check
      # if the controller renders the template with the given name.
      expect(response).to render_template(:new)

    end

    it "instantiates a new Campaign object and sets it to @campaign" do
      get :new
      expect(assigns(:campaign)).to be_a_new(Campaign)
    end
  end

  describe "#create" do
    before { signin(user) }
    context "with valid attributes" do
      def valid_request
        post :create, campaign: {name: "some valid name",
                                 description: "some valid description",
                                 goal: 1000000
                                 }

      end


      it "creates a record in the database" do
        campaign_count_before = Campaign.count
        valid_request
        campaign_count_after = Campaign.count
        expect(campaign_count_after - campaign_count_before).to eq(1)
      end

      it "redirects to the campaign show page" do
        valid_request
        expect(response).to redirect_to(campaign_path(Campaign.last))
      end
      it "sets a flash message" do
        valid_request
        expect(flash[:notice]).to be
      end
    end
    context "with invalid attributes" do
      def invalid_request
        post :create, campaign: {
                                 description: "some valid description",
                                 goal: 1000000
                                 }

      end
      it "doesn't create a record in the database" do
      #GIVEN
      campaign_count_before = Campaign.count
      invalid_request
      #WHEN
      campaign_count_after = Campaign.count
      #THEN
      expect(campaign_count_after).to eq(campaign_count_before)

    end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)

      end

      it "sets a flash alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end

    end
  end

  describe "#show" do
    before do
      #GIVEN:
        @campaign = Campaign.create({name: "valid name",
                                      description: "valid description",
                                      goal: 1000000})
      #WHEN:
        get :show, id: @campaign.id
      end

    it "find the object by its id sets to @campaign variable" do
      # Always assume that you are starting to clean database
      #THEN:
        expect(assigns(:campaign)).to eq(@campaign)
        # assigns, method will look for instance variable

    end
    it "renders the show template" do

      #THEN:
        expect(response).to render_template(:show)
    end
    it "raises an error if the id passed doesn't match the record in the DB" do
      # not using the response, instead putting a code that will raise an error
      expect { get :show, id: 234324234 }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  describe "#index" do
    it "renders the index template" do
      #THEN
      get :index
      expect(response).to render_template(:index)

    end

    it "fetches all records and assigns them to @campaigns" do
      #GIVEN
      c = FactoryGirl.create(:campaign)
      c1 = FactoryGirl.create(:campaign)
      #WHEN
      get :index
      #THEN
      expect(assigns(:campaigns)).to eq([c, c1])
      # assigns is used to get instance variable
    end
  end

  describe "#edit" do
    before { signin(user) }
    before do
      #WHEN
      get :edit, id: campaign
    end

    it "renders the edit template" do
      #THEN
      expect(response).to render_template(:edit)
    end
    it "finds the campaign by id and sets it to @campaign instance variable" do
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "#update" do
    before { signin(user) }
    context "with valid attributes" do
      before do
        patch :update, id: campaign.id, campaign: {name: "new valid name"}
      end
      it "updates the record with new parameters(s)" do
        # GIVEN:
          # We need to have a campaign create in the DB.
          # 1. need to have a record, we can make the use of 'campaign' variable we defined using 'let'
          # at the top

        # WHEN:
        #mimicking http structure
        # patch :update, id: campaign.id, campaign: {name: "new valid name"}

        # THEN:
        # We must use campaign.reload in this scenario because the controller
        # will instantiate another campaign object based on the id but it will
        # live in another memory location. Which menas 'campaign' here will still
        # have the old data not the possibly updated one. Reload will make
        # ActiveRecord rerun the query and fetches the information from the DB
        # again.
        expect(campaign.reload.name).to eq("new valid name")

      end

      it "redirect to the campaign show page" do
        expect(response).to redirect_to(campaign_path(campaign.reload!))
        # when you render you get 200
      end


      it "sets a flash message" do
        expect(flash[:notice]).to be
        #.to be == meaning not nil
        #.to_not be
      end

    context "with invalid attributes" do
      before do
        @goal_before = campaign.goal
        patch :update, id: campaign.id, campaign: {goal: 6 }

      end

      it "doesn't update the record" do
        #GIVEN
        #WHEN
        #THEN
        expect(campaign.reload.goal).to eq(@goal_before)
      end

      it "renders the edit template" do
      expect(response).to render_template :edit
    end

      it "sets a flash alert message" do
        expect(flash[:alert]).to be
      end
    end
  end

  describe "#destroy" do

    context "signed in user" do
      before { signin(user) }
      context "authorize user" do
        it "destroys the campaign record in the DB" do
          campaign
          count_before = Campaign.count
          delete :destroy, id: campaign
          count_after = Campaign.count
          expect(count_after - count_before).to eq(-1)
        end
        it "redirects to homepage" do
          delete :destroy, id: campaign
          expect(response).to redirect_to(root_path)
        end
      end
      context "unauthorize user" do
        it "raises an error" do
          expect do
            delete :destroy, id: campaign_1
          end.to raise_error(ActiveRecord::RecordNotFound)

        end


      end

    end

    context "unautheticated user" do

      it "redirects the user to sign in page" do
        delete :destroy, id: campaign
        expect(response).to redirect_to(root_path)
      end



    end


    it "removes the campaigns form the database" do
      # campaign
      # expect { delete :destroy, id: campaign.id }.to change {Campaign.count}.by(-1)
      campaign # will create campaign
      campaign_before = Campaign.count
      delete :destroy, id: campaign.id
      expect(campaign_before - 1).to eq(Campaign.count)
    end
    it "redirects to the campaign page" do
      delete :destroy, id: campaign
      expect(response).to redirect_to(root_path)
    end

    it "sets a flash message" do
      delete :destroy, id: campaign.id
      expect(flash[:alert]).to be
    end




  end
end

end
