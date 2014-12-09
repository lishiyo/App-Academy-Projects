class CommentsController < ApplicationController

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)
    # @comment.parent_comment_id = @parent_comment.id

    if @comment.save
      redirect_to post_url(@comment.post)
    else
      flash[:errors] = "Cannot post comment"
      render post_url(@comment.post)
    end
  end

  def show
    @parent_comment = Comment.find(params[:id])
    @comment = Comment.new
  end


  private
  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end
end
