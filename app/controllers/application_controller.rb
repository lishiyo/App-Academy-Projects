class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    return nil if session[:session_token].nil?

    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  # forces a boolean true/false
  def signed_in?
    !!current_user
  end

  # called upon successful creation of new user
  def login!(user)
    user.reset_session_token!
    @current_user = user # set current_user upon login
    session[:session_token] = user.session_token
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def require_current_owner
    unless @cat.owner == current_user
      redirect_to cat_url(@cat), notice: "You are not authorized to change this cat."
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
