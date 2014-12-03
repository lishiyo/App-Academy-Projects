class GroupsController < ApplicationController

  before_action :set_group, only: [:show, :update, :destroy, :add_member, :destroy_member]
  def index
    @user = User.find(params[:user_id])
    @groups = @user.groups

    render json: @groups
  end

  def show
    render json: @group
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      render json: @group
    else
      render json: @group.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy

    render json: @group
  end

  def add_member
    @group_membership = @group.group_memberships.new(contact_id: params[:contact_id])
    if @group_membership.save
      render json: @group
    else
      render json: @group_membership.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy_member
    @group_membership = @group.group_memberships.find(params[:group_membership_id])
    @group_membership.destroy

    render json: @group
  end

  private

  def group_params
    params.require(:group).permit(:name, :owner_id)
  end

  def set_group
    @group = Group.find(params[:id])
  end

end
