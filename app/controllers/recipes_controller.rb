class RecipesController < ApplicationController

  def new
    @recipe = Recipe.new
    @ingredients_attributes = []
    @ingredients_attributes << {name: nil, quantity: nil}
  end
  
end
