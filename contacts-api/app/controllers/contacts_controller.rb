class ContactsController < ApplicationController

  before_action :set_contact, only: [:show, :update, :favorite, :unfavorite, :destroy]

  def index
    @user = User.find(params[:user_id])
    @contacts = @user.all_contacts
    render json: @contacts
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      render json: @contact
    else
      render json: @contact.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    render json: @contact
  end

  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    render json: @contact
  end

  def favorite
    @contact.favorited = true
    render json: @contact
  end

  def unfavorite
    @contact.favorited = false
    render json: @contact
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :user_id)
  end

end
