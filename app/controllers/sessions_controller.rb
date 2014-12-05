class SessionsController < ApplicationController

  before_action :redirect_to_cats_index, only: [:new, :create]

  def new
  end

  def create
    # finds and verifies @user exists in database
    @user = User.find_by_credentials(user_params[:user_name], user_params[:password])
    if @user
      login!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] << "No such user"
      render :new
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  def redirect_to_cats_index
    redirect_to cats_url if signed_in?
  end

end
