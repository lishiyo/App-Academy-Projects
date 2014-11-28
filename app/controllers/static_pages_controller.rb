class StaticPagesController < ApplicationController

  def index
  end
	
	def submit
	end

	def create_short_url
		
		user_name = submission_params[:name]
		user_email = submission_params[:email]
		user_long_url = submission_params[:long_url]
		tags = Array.new.push(submission_params[:tags])
		
		user = User.where(name: user_name, email: user_email).first_or_create
		
		shortened_url = ShortenedUrl.create_for_user_and_long_url!(user, submission_params[:long_url])
		respond_to do |format|
			format.html do
				if shortened_url.save
					Visit.record_visit!(user, shortened_url) # record as a visit 
					tags.each do |tag| 
						new_tag = TagTopic.create!(topic: tag)
						Tagging.create!(shortened_url_id: shortened_url.id, tag_id: new_tag.id)
					end
						
					flash[:success] = "here ya go, #{user.name}!"
					redirect_to user_path(user)
				else
					flash[:danger] = "submission failed"
					redirect_to root_url
				end
			end
    end
	end
	
	private 
	
	def submission_params
		params.require(:user).permit(:long_url, :submitter_id, :name, :email, :tags)
	end

end
