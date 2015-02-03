class TagTopicsController < ApplicationController
	
	def index
		@tag_topics = TagTopic.topics
	end
	
	def new
	end
	
	def create
	end
	
	def show
		@tagtopic = TagTopic.find(params[:id])
	end
	
	
	def destroy
	end
	
	
end
