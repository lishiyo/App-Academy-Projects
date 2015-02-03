class SessionsController < ApplicationController

  wrap_parameters false

  def new
    @user = User.new
    render json: @user
  end

  def create
    @user = User.find_by_credentials(user_params[:username], user_params[:password])
    if @user
      log_in(@user)
      redirect_to root_url
    else
      render json: @user.errors.full_messages, status: 422
    end
  end

  def destroy
    @user = current_user
    log_out
    redirect_to root_url
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
