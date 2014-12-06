class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def login!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

	# username and password params only available in Users#create, Sessions#create
  def current_user
    # return nil if session[:session_token].nil?
		return @current_user if @current_user
		
		if session[:session_token]	
			@current_user = User.find_by(session_token: session[:session_token])
			return @current_user
		elsif cookies.signed[:user_id]
			user = User.find_by(id: cookies.signed[:user_id])
			if user && user.is_remember_token?(cookies[:remember_token])
				@current_user = user
				return @current_user
			end
		end
		
		nil
  end

  def logout!
    current_user.try(:reset_session_token!)
		forget(current_user)
    session[:session_token] = nil
  end
	
	def signed_in? 
		!!current_user
	end
	
	# requires user to be logged in
	def require_current_user!
		redirect_to new_session_url if current_user.nil?
	end
	
	def require_same_user!
		user = User.find(params[:id])
		unless user == current_user
			flash[:notice] = "You are not authorized to view this profile."
			redirect_to new_session_url
		end
	end
	
end
