class ShortenedUrlsController < ApplicationController
	
	def index
		@shortened_urls = ShortenedUrl.all
	end
	
	
	def new
		@shortened_url = ShortenedUrl.new
	end
	
	def show
		
	end
	
	# POST /shortened_urls
	def create
		user_name = submission_params[:name]
		user_email = submission_params[:email]
		user_long_url = submission_params[:long_url]
		tags = Array.new.push(submission_params[:tags])
		
		user = User.where(name: user_name, email: user_email).first_or_create
		
		shortened_url = ShortenedUrl.create_for_user_and_long_url!(user, submission_params[:long_url])
		respond_to do |format|
			format.html do
				if shortened_url.save
					# record as a visit 
					Visit.record_visit!(user, shortened_url)
					# create TagTopics if necessary, attach tags
					tags.each do |tag| 
						new_tag = TagTopic.first_or_create!(topic: tag)
						Tagging.create!(shortened_url_id: shortened_url.id, tag_id: new_tag.id)
					end
						
					flash[:success] = "here ya go, #{user.name}!"
					redirect_to user_path(user)
				else
					flash.now[:danger] = "submission failed"
					render root_url
				end
			end
    end
	end
	
	# POST /launch 
	def launch
		p params
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
		params.require(:user).permit(:long_url, :submitter_id, :name, :email, :tags)
	end
	
	def launch_params
		params.permit(:short_url)
	end
	
end
