class ShortenedUrlsController < ApplicationController
	
	def index
		@shortened_urls = ShortenedUrl.all
	end
	
	
	def new
		@shortened_url = ShortenedUrl.new
	end
	
	def show
		
	end
	
	def create
		
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
	
	
end
