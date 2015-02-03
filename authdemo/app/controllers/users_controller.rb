class UsersController < ApplicationController

  respond_to :html, :json

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        login!(@user)
        format.html do
          redirect_to user_url(@user), notice: "User was created!"
        end
        format.json { render json: @user }
      else

        format.html do
          flash[:danger] = 'Something went wrong.'
          render :new
        end

        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end


  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
