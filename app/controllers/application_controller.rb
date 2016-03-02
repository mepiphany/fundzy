class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user
    redirect_to new_session_path unless session[:user_id]
  end

  def current_user
    @current_user ||= User.find session[:user_id] if user_logged_in?
  end
  helper_method :current_user

  def user_logged_in?
    session[:user_id].present?
  end
  helper_method :user_logged_in?




end
