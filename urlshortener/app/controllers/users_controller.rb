class UsersController < ApplicationController

	respond_to :html, :json
	
	def index
		@users = User.all
	end
	
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)   
    if @user.save
			login!(@user)
			redirect_to user_url(@user), notice: "Your account was created."
    else
			flash.now[:danger] = 'Oops! Someone seems to have taken that account.'
      render :new
    end
  end
	
	def show
    @user = User.find(params[:id])
		@submitted_urls = @user.submitted_urls
		@last_short_url = @submitted_urls.empty? ? nil : @submitted_urls.last.short_url
  end
	
	def destroy
	end

  private

  def user_params
		params.require(:user).permit(:email, :username, :password)
  end
	
end
