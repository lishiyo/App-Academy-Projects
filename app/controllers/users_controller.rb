class UsersController < ApplicationController

	def index
		@users = User.all
	end
	
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)   
    if @user.save
      redirect_to root_url
    else
      render 'new'
    end
  end
	
	def show
    @user = User.find(params[:id])
		@submitted_urls = @user.submitted_urls
		@last_short_url = @submitted_urls.empty? ? "" : @submitted_urls.last.short_url
		
  end
	
	def delete
		
	end

  private

  def user_params
		params.require(:user).permit(:email, :name)
  end
	
end
