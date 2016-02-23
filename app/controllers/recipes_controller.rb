class RecipesController < ApplicationController
  before_action :require_login, only:[:new, :create, :edit, :update, :destroy]
  before_action :set_recipe, only:[:edit, :update, :show, :destroy]
  #before_action :recipe_check, only:[:edit, :update, :destroy]

  def new
    if !!params[:user_id]
      if params[:user_id] != current_user.id
        flash[:alert] = "You are not authorized to do that"
        redirect_to user_path(current_user)
      end
    end
    @recipe = Recipe.new(user: current_user)
  end

  def index
    @recipes = Recipe.all
  end

  def create
    binding.pry
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
    authorize(@recipe)
  end
    
  def update
    binding.pry
    authorize(@recipe)
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
      if Recipe.exists?(params[:id])
        @recipe = Recipe.find(params[:id])
      else
        flash[:alert] = "Recipe does not exist"
        if logged_in?  
          redirect_to user_path(current_user)
        else 
          redirect_to root_path
        end
      end
    end

    def add_ingredient
      @recipe.add_ingredient(params[:recipe][:recipe_ingredients])
      flash[:notice] = "Ingredient has been added"
    end

    #def recipe_check
    #  if @recipe.user != nil && @recipe.user != current_user 
    #    flash[:alert] = "Users can only edit/create/destroy their own recipes"
    #    redirect_to user_path(current_user)
    #  end
    #end

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
