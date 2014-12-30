class Api::UsersController < ApplicationController

  wrap_parameters false

  def new
    @user = User.new()
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      render json: @user
    else
      render json: @user.errors.full_messages, status: 422
    end
  end

  def show
    @user = User.find(params[:id])
    render json: @user, include: :feeds
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
