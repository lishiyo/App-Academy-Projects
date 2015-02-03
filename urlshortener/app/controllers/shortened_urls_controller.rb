class ShortenedUrlsController < ApplicationController
	
	def index
		@shortened_urls = ShortenedUrl.all
	end
	
	
	def new
		@shortened_url = ShortenedUrl.new
	end
	
	
	# POST /shortened_urls
	def create
# 		user_name = submission_params[:name]
# 		user_email = submission_params[:email]
		user_long_url = submission_params[:long_url]
		tags = submission_params[:tags].split(",").map(&:strip)
		
		# user = User.where(name: user_name, email: user_email).first_or_create
		if current_user
			@user = current_user
		else
			user_credentials = [login_params[:email], login_params[:password]]
			@user = User.find_by_credentials(*user_credentials)
			
			if @user.nil?
				flash[:danger] = "Invalid login info."
				redirect_to :back
				return
				# redirect_to :back
			else
				login!(@user) # session[:session_token] = user.session_token
			end
			
		end
		
		# special ShortenedUrl method to ensure :short_url is created 
		shortened_url = ShortenedUrl.create_for_user_and_long_url!(@user, submission_params[:long_url])
	
		respond_to do |format|
			format.html do
				if shortened_url.save
					# record visit and attach taggings
					shortened_url.class.transaction do 
						Visit.record_visit!(@user, shortened_url)
						# create TagTopics if necessary, and attach tags
						tags.each do |tag| 
							new_tag = TagTopic.find_or_create_by(topic: tag)
							shortened_url.taggings.create!(tag_id: new_tag.id)
						end
						
					end
					flash[:success] = "here ya go, #{@user.username}!"
					redirect_to user_path(@user)
				else
					flash.now[:danger] = "Logged in, but submission failed"
					render root_url
				end
			end
		end

		
	end
	
	# POST /launch 
	def launch
		long_url = ShortenedUrl.find_by_short_url(launch_params[:short_url].strip).long_url
		redirect_to long_url
	end
	
	def destroy
		shortened_url = ShortenedUrl.find(params[:id])
		shortened_url.destroy
    respond_to do |format|
  		format.html { redirect_to :back }
  		format.json { head :no_content }
		end
	end
	
	private
	
	def submission_params
		params.require(:shortened_url).permit(:long_url, :tags)
	end
	
	def login_params
		params.require(:user).permit(:username, :email, :password)
	end
	
	def launch_params
		params.permit(:short_url)
	end
	
end
