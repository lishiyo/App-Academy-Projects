class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    return nil if session[:session_token].nil?

    # @current_user ||= User.find_by(session_token: session[:session_token])
    @current_user ||= UserSessionOwnership
      .find_by(session_token: session[:session_token]).user
  end

  # forces a boolean true/false
  def signed_in?
    !!current_user
  end

  # called upon successful creation of new user
  def login!(user)
    user.reset_session_token!
    # curr_session_token == user.session_token
    # sets user.curr_session_token and persists to UserSessionsOwnership table
    user.set_curr_session_token
    @current_user = user # set current_user upon login
    # session[:session_token] = user.session_token
    session[:session_token] = user.curr_session_token
  end

  def logout!
    current_user.reset_session_token!

    # delete row in UserSessionOwnership
    UserSessionOwnership.destroy_all(session_token: current_user.curr_session_token)
    # clear out so curr_session_token has to reset with actual user.session_token

    session[:session_token] = nil
  end

  def require_current_owner
    unless @cat.owner == current_user
      redirect_to cat_url(@cat), notice: "You are not authorized to change this cat."
    end
  end

  def require_user_is_signed_in
    redirect_to :back, notice: "You must be signed in to make a rental request." unless signed_in?
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
