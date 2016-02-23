class RecipesController < ApplicationController
  before_action :set_recipe, only:[:edit, :update, :show, :destroy]
  before_action :recipe_check, only:[:edit, :update, :destroy]

  def new
    @recipe = Recipe.new
  end

  def index
    @recipes = Recipe.all
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if !!params[:add_ingredient]
      add_ingredient
      render :new
    else
      recipe_save
    end
  end

  def show
  end

  def edit
  end
    
  def update
    if !!params[:add_ingredient]
      add_ingredient
      render :edit
    else
      recipe_save
    end
  end

  def destroy
    @recipe.destroy
    flash[:notice] = "Recipe successfully deleted"
    redirect_to user_path(current_user)
  end

  
  private

    def recipe_params
      params.require(:recipe).permit(:name, :content)
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def add_ingredient
      @recipe.add_ingredient(params[:recipe][:recipe_ingredients])
      flash[:notice] = "Ingredient has been added"
    end

    def recipe_check
      if !@recipe 
        flash[:alert] = "Invalid Recipe Page" 
        redirect_to root_path
      elsif @recipe.user != nil && @recipe.user != current_user 
        flash[:alert] = "Users can only edit/create/destroy their own recipes"
        redirect_to user_path(current_user)
      end
    end

    def recipe_save
      if !@recipe.user || @recipe.user == current_user
        @recipe.user ||= current_user
        @recipe.save
        flash[:notice] = "Recipe successfully submitted"
        redirect_to recipe_path(@recipe)
      else
        flash[:alert] = "Users can only save their own recipes"
        redirect_to user_path(@user)
      end
    end

end
