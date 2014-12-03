class CommentsController < ApplicationController

  def index

  end

  def create
  end

  def destroy
  end

  private

  def find_commentable
    # contact_id OR user_id
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def comment_params

  end


end
