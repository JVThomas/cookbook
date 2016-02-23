class RecipesController < ApplicationController
  before_action :require_login, only:[:new, :create, :edit, :update, :destroy]
  before_action :user_check, only:[:new, :create, :edit, :update, :destroy,:show]
  before_action :set_recipe, only:[:edit, :update, :show, :destroy]
  before_action :recipe_check, only:[:edit, :update, :destroy]

  def new
    @recipe = Recipe.new
    if !!params[:user_id]  && params[:user] != current_user.id
      binding.pry
      flash[:alert] = "Access Denied. Users can only create recipes under their own account"
      redirect_to user_path(current_user)
    else
      binding.pry
      @recipe.user = current_user
    end
  end

  def index
    if !!params[:user_id]
      @recipes = User.find(params[:user_id]).recipes
    else
      @recipes = Recipe.all
    end
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
    if !!params[:user_id]
      if params[:user_id] != current_user.id
        flash[:alert] = "Access Denied. Users can only edit recipes under their own account"
        redirect_to user_path(current_user)
      end
    end
  end
    
  def update
    @recipe.update(recipe_params)
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
        redirect_to user_path(current_user)
      end
    end

    def add_ingredient
      @recipe.add_ingredient(params[:recipe][:recipe_ingredients])
      flash[:notice] = "Ingredient has been added"
    end

    def recipe_check
      if @recipe.user != nil && @recipe.user != current_user 
        flash[:alert] = "Users can only edit/create/destroy their own recipes"
        redirect_to user_path(current_user)
      end
    end

    def recipe_save
      if !@recipe.user || @recipe.user == current_user
        @recipe.user ||= current_user
        if @recipe.save
          flash[:notice] = "Recipe successfully submitted"
          redirect_to recipe_path(@recipe)
        else
          flash[:alert] = "Recipe did not save successfully"
          redirect_to user_path(current_user)
        end
      else
        flash[:alert] = "Users can only save their own recipes"
        redirect_to user_path(current_user)
      end
    end

    def user_check
      if !!params[:user_id]
        if !User.exists?(params[:user_id])
          flash[:alert] = "User does not exist"
          redirect_to user_path(current_user)
        end
      end
    end

end
