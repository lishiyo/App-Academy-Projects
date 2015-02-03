class ContactSharesController < ApplicationController

  before_action :set_contact_share, only: [:destroy, :favorite, :unfavorite]
  def create
    @contact_share = ContactShare.new(contact_params)
    if @contact_share.save
      render json: @contact_share
    else
      render json: @contact_share.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @contact_share.destroy

    render json: @contact_share
  end


  def favorite
    @contact_share.favorited = true
    render json: @contact_share
  end

  def unfavorite
    @contact_share.favorited = false
    render json: @contact_share
  end

  private

  def set_contact_share
    @contact_share = ContactShare.find(params[:id])
  end

  def contact_params
    params[:contact_share].permit(:contact_id, :user_id)
  end

end
