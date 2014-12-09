class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :require_current_user, :current_user


  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !!current_user
  end

  def require_current_user
    redirect_to new_session_url unless logged_in?
  end

  def login!(user)
    @current_user = user
    user.reset_session_token
    session[:session_token] = user.session_token
  end

  def logout!
    current_user.try(:reset_session_token)
    session[:session_token] = nil
  end

end
