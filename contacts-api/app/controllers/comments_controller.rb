class CommentsController < ApplicationController

  def index
    @comments_owner = find_commentable
    @comments = @comments_owner.comments
    render json: @comments
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render json: @comment
    else
      render json: @contact.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    render json: @comment
  end

  private

  def find_commentable
    # contact_id OR user_id => Contact.find(1)
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :text)
  end


end
