class RecipesController < ApplicationController

  def new
    @recipe = Recipe.new
    ingredients_attributes = []
    ingredients_attributes << {name: nil, quantity: nil}
  end

  def add_ingredient
    ingredients_attributes = params[:ingredients_attributes]
    ingredients_attributes << {name: nil, quantity: nil}
    if !!params[:id]
      render :edit
    else
      render :new
    end
  end

end
