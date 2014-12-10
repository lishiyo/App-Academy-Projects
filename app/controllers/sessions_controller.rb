class SessionsController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(user_params[:username], user_params[:password])

    if @user.nil?
      flash.now[:errors] = ["Couldn't find user with those credentials."]
      render :new
    else
      login!(@user)
      redirect_to user_url(@user)
    end

  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
