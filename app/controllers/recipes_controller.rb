class RecipesController < ApplicationController
  before_action :require_login, only:[:new, :create, :edit, :update, :destroy]
  before_action :set_recipe, only:[:edit, :update, :show, :destroy]
  before_action :params_check, only:[:new, :create]
  before_action :set_user, only:[:index,:show]

  def new
    @recipe = Recipe.new
  end

  def index
    if !!params[:search]
      ingredient_search
    elsif !!@user
      @recipes = Recipe.where(user_id:@user.id)
    else 
      @recipes = Recipe.all
    end
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if !!params[:add_ingredient]
      add_ingredient(:new)
    else
      recipe_save(:new)
    end
  end

  def show
    @comment = Comment.new
    if !!@user && @user.id != @recipe.user.id
      flash[:alert] = "Recipe does not belong to specified user"
      home_redirect
    end
  end

  def edit
    authorize(@recipe)
  end
    
  def update
    authorize(@recipe)
    if !!params[:add_ingredient]
      add_ingredient(:edit)
    else
      recipe_save(:edit)
    end
  end

  def destroy
    authorize(@recipe)
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
        home_redirect
      end
    end

    def add_ingredient(sym)
      @recipe.add_ingredient(params[:recipe][:recipe_ingredients])
      flash[:notice] = "Ingredient has been added" if !@recipe.errors.any?
      render sym
    end

    def recipe_save(sym)
      if @recipe.user == current_user
        @recipe.update(recipe_params) if sym == :edit
        if @recipe.valid?
          @recipe.save if sym == :new
          flash[:notice] = "Recipe successfully submited"
          redirect_to recipe_path(@recipe)
        else
          render sym
        end
      else
        flash[:alert] = "Users can only save their own recipes"
        redirect_to user_path(current_user)
      end
    end

    def ingredient_search
      if params[:ingredient_name].blank?
        flash[:alert] = "Search field empty. Returned to previous page"
        redirect_to :back
      else
        @recipes = Recipe.search_by_ingredient(params[:ingredient_name])
        flash[:notice] = "Search successfully completed. #{@recipes.length} result(s) found"
      end
    end
end