class SubsController < ApplicationController

  before_action :set_sub, only: [:show, :edit, :update, :require_current_moderator]
  before_action :require_current_moderator, only: [:edit, :update]

  def index
    @subs = Sub.all
  end


  def show
    # sort comments by score
    
  end

  def new
    @sub = Sub.new
  end

  def create
    #user_id automatically set to current_user
    @sub = current_user.subs.build(sub_params)

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = "Not a valid sub."
      render
    end

  end

  def edit
  end

  def update
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = "Couldn't update sub."
    end
  end


  private

  def require_current_moderator
    unless current_user == @sub.moderator
      redirect_to sub_url(@sub), notice: "You are not authorized."
    end
  end

  def set_sub
    @sub = Sub.find(params[:id])
  end

  def sub_params
    params.require(:sub).permit(:title, :description, :user_id)
  end

end
