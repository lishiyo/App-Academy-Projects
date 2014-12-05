class CatRentalRequestsController < ApplicationController

  before_action :set_cat_options
  before_action :set_rental_request_and_cat, only: [:show, :edit, :update,
      :destroy, :require_current_owner, :approve, :deny, :require_current_requester]
  before_action :require_current_owner, only: [:approve, :deny]
  before_action :require_user_is_signed_in, only: [:new, :create]
  before_action :require_current_requester, only: [:edit, :update, :destroy]

  def new
    @cat = Cat.find(params[:cat_id])
    @cat_rental_request = @cat.cat_rental_requests.build
  end

  def create
    @cat_rental_request = current_user.rental_requests.build(request_params)

    if @cat_rental_request.save
      flash[:success] = "Your rental request is in processing."
      redirect_to cat_url(@cat_rental_request.cat)
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :new
    end

  end

  # you must be the owner of this rental request
  def edit
  end

  def update
    if @cat_rental_request.update(request_params)
      flash[:success] = "Your rental request has been updated."
      redirect_to cat_url(@cat_rental_request.cat)
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :edit
    end
  end

  def approve
    @cat_rental_request.approve!
    redirect_to cat_url(@cat_rental_request.cat)
  end

  def deny
    @cat_rental_request.deny!
    redirect_to cat_url(@cat_rental_request.cat)
  end

  private

  # for edit, update, destroy
  def require_current_requester
    unless @cat_rental_request.requester == current_user
      redirect_to cat_url(@cat), notice: "You are not authorized to change this rental request."
    end
  end

  def set_rental_request_and_cat
    @cat_rental_request = CatRentalRequest.includes(:cat).includes(:requester).find(params[:id])
    @cat = @cat_rental_request.cat
  end

  def set_cat_options
    @cat_options = Cat.all
  end

  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :user_id)
  end

end
