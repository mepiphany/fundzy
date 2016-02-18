class UsersController < ApplicationController
  def new
    @user = User.new

  end
  def create
    @user = User.new (params.require(:user).permit([:first_name, :last_name,
      :email, :password, :pasword_confirmation]))
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "successful"
    else
      flash[:alert] ="Fail!"
      render :new
    end
  end
end