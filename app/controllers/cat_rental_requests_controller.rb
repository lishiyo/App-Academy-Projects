class CatRentalRequestsController < ApplicationController

  before_action :set_cat_options
  before_action :find_rental_request, only: [:show, :edit, :update, :destroy, :approve, :deny]

  def new
    @cat = Cat.find(params[:cat_id])
    @cat_rental_request = @cat.cat_rental_requests.build
  end

  def create
    @cat_rental_request = CatRentalRequest.new(request_params)

    if @cat_rental_request.save
      flash[:success] = "Your rental request is in processing."
      redirect_to cat_url(@cat_rental_request.cat)
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :new
    end

  end

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

  def find_rental_request
    @cat_rental_request = CatRentalRequest.find(params[:id])
  end

  def set_cat_options
    @cat_options = Cat.all
  end

  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
