class SessionsController < ApplicationController

  before_action :find_user, only: [:create]

  def new
  end

  def create
    if @user.nil?
      render json: "Credentials were wrong."
    else
			login!(@user) # set session[:session_token] = user.session_token
      redirect_to user_url(@user)
      # render json: "Welcome back, #{@user.username}!"
    end
  end

  def destroy
		logout! # POST /session => reset current_user's session_token, set session[:session_token] to nil
		redirect_to new_session_url
  end

  private

  def find_user
		# returns nil if no user with this username and password
    @user = User.find_by_credentials(*user_credentials)
  end

  def user_credentials
		[params[:user][:email], params[:user][:password]]
  end

end
