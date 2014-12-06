class SessionsController < ApplicationController
	include SessionsHelper

  before_action :find_user, only: [:create]

  def new
  end

  def create
		if @user.nil? # find_user returned nil
			flash.now[:danger] = "Couldn't find user with those credentials."
			render :new
    else
			login!(@user) # set session[:session_token] = user.session_token
			params[:session] ? remember(@user) : forget(@user)
			flash[:success] = "Welcome back, #{@user.username}!"
			redirect_to @user
      # render json: "Welcome back, #{@user.username}!"
    end
  end

  def destroy
		logout! if signed_in? 
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
