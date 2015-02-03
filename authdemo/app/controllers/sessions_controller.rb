class SessionsController < ApplicationController

  before_action :find_user, only: [:create, :destroy]

  def new
  end

  def create
    if @user.nil?
      render json: "Credentials were wrong."
    else
      login!(user) # credentials were right
      redirect_to user_url(user)
      # render json: "Welcome back, #{@user.username}!"
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  private

  def find_user
    # returns nil if can't find user with these credentials
    @user = User.find_by_credentials(*user_credentials)
  end

  def user_credentials
    [params[:user][:username], params[:user][:password]]
  end

end
