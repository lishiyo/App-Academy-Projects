class CatsController < ApplicationController

  before_action :color_options

  def index
    @cats = Cat.all
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      flash[:success] = "#{@cat.name} was successfully created."
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update #in current form, probably only returns original values
    @cat = Cat.find(params[:id])
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
    @cat = Cat.find(params[:id])
    # array of attributes that are not nil
    @attributes = Array.new
    @cat.attributes.each do |attr_name, value|
      next if (value.nil?) || (attr_name.match("_at"))
      @attributes << [attr_name,value]
    end
  end

  private

  def color_options
    @color_options = Cat::COLORS
  end

  def cat_params
    params.require(:cat).permit(:name, :color, :birth_date, :sex, :description)
  end

end
