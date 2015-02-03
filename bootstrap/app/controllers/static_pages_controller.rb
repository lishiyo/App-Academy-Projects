class StaticPagesController < ApplicationController
	
  def home
  end

  def contact
  end

  def about
		@paragraph = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam id turpis quis nisi bibendum auctor non ac sapien. Sed sapien orci, egestas vel vehicula sit amet, vestibulum id ante. Maecenas sed condimentum turpis. Etiam volutpat erat ac odio volutpat semper."
  end
	
end
