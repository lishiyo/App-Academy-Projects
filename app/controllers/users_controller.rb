class UsersController < ApplicationController

  before_action :require_signed_in, except: [:new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @goals = @user.goals
    @goal = @user.goals.new #for creating a new goal form
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end

  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
