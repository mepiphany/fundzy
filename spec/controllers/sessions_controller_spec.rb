require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "#new" do
    it "renders the new template" do
    get :new
    expect(response).to render_template(:new)
  end
end

  describe "#create" do
    context "with valid credentials" do
      it "sets the session user_id to the user with the passed email" do
        #GIVEN
        @user = FactoryGirl.create(:user)
        #WHEN
        post :create, {email: @user.email, password: @user.password}
        #THEN
        expect(session[:user_id]).to eq(@user.id)

      end

      it "redirect to the root_path" do
        @user = FactoryGirl.create(:user)
        post :create, {email: @user.email, password: @user.password}
        expect(response).to redirect_to(root_path)
    end
      it "sets a flash notice message" do
        @user = FactoryGirl.create(:user)
        post :create, {email: @user.email, password: @user.password}
        expect(flash[:notice]).to be

      end

  end
    context "with invalid credentials" do
      it "renders the sign-in page (new template)" do
        @user = FactoryGirl.create(:user)
        post :create, {email: @user.email, password: @user.password + "a"}
        expect(response).to render_template(:new)
      end

      it "sets a flash alert message" do
        @user = FactoryGirl.create(:user)
        post :create, {email: @user.email, password: @user.password + "a"}
        expect(flash[:alert]).to be

      end

      it "doesn't set session user_id if email is correct and password is wrong" do
        @user = FactoryGirl.create(:user)
        post :create, {email: @user.email, password: @user.password + "a"}
        expect(session[:user_id]).to eq(nil)
      end

  end
end
  describe "#destroy" do
    it "sets the session user_id to nil" do
      @user = FactoryGirl.create(:user)
      request.session[:user_id] = @user.id
      delete :destroy
      expect(session[:user_id]).not_to be
  end

    it "sets a flash notice message" do
      @user = FactoryGirl.create(:user)
      request.session[:user_id] = @user.id
      delete :destroy
      expect(flash[:notice]).to be
    end

    it "redirects to the root_path " do
      @user = FactoryGirl.create(:user)
      request.session[:user_id] = @user.id
      delete :destroy
      expect(response).to redirect_to(root_path)
    end

end


end
