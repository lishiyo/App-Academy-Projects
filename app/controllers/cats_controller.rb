class CatsController < ApplicationController

  before_action :color_options
  before_action :set_cat, only: [:show, :edit, :update, :destroy, :require_current_owner]
  before_action :require_current_owner, only: [:edit, :update, :destroy]

  def index
    @cats = Cat.all
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    # @cat = current_user.cats.build(cat_params)
    if @cat.save
      flash[:success] = "#{@cat.name} was successfully created."
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update #in current form, probably only returns original values
    if @cat.update(cat_params)
      # message is a string
      flash[:success] = "#{@cat.name} was successfully updated"
      redirect_to cat_url(@cat)
    else
      # array
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  def show
    # array of attributes that are not nil
    @attributes = Array.new
    @cat.attributes.each do |attr_name, value|
      next if (value.nil?) || (attr_name.match("_at"))
      @attributes << [attr_name,value]
    end
  end

  private

  def set_cat
    @cat = Cat.find(params[:id])
  end

  def color_options
    @color_options = Cat::COLORS
  end

  def cat_params
    params.require(:cat).permit(:name, :color, :birth_date, :sex, :description)
  end

end
