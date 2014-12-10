class GoalsController < ApplicationController

  before_action :set_goal, only: [:edit, :update, :destroy]

  def create
    @goal = current_user.goals.build(goal_params)

    if @goal.save
      redirect_to user_url(current_user)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render user_url(current_user)
    end
  end

  def edit
  end

  def update
    @goal.completed = goal_params["completed"].nil? ? false : true
    @goal.public = goal_params["public"].nil? ? false : true
    p @goal
    if @goal.update(name: goal_params["name"],
      content: goal_params["content"],
      deadline: goal_params["deadline"],
      completed: @goal.completed,
      public: @goal.public
      )
      respond_to do |format|
        format.html { redirect_to user_url(current_user) }
        format.js { render nothing: true }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:errors] = @goal.errors.full_messages
          render user_url(current_user)
        end
        format.js { render nothing: true }
      end
    end
  end

  def destroy
    @goal.destroy
    redirect_to user_url(current_user)
  end

  private

  def set_goal
    @goal = Goal.find(params[:id])
  end

  def goal_params
      params.require(:goal).permit(:name, :content, :user_id, { completed: [] }, { public: [] }, :deadline, :completed, :public)
  end

end
