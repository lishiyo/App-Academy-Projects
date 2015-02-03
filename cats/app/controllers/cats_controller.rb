class CatsController < ApplicationController

  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find(params[:id])
    @attribute_names = @cat.attributes.keys[1..-3]
  end

  def new
    @cat = Cat.new
    @color_options = Cat::COLORS.zip(Cat::COLORS)
  end

  def create
    p cat_params
    
    cat = Cat.new(cat_params)
    if cat.save
      flash[:success] = "Cat saved!"
      redirect_to cat_path(cat)
    else
      flash[:danger] = "Something went wrong."
      redirect_to new_cat_url
    end
  end

  def edit
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :sex, :birth_date, :color, :description)
  end

end
