class RecipesController < ApplicationController
  before_action :require_login, only:[:new, :create, :edit, :update, :destroy]
  before_action :set_recipe, only:[:edit, :update, :show, :destroy]
  before_action :params_check, only:[:new, :create]

  def new
    params_check
    @recipe = Recipe.new
  end

  def index
    if !!params[:user_id]
      if User.exists?(params[:user_id])
        @user_bool = true
        @recipes = Recipe.where(user_id: params[:user_id])
      else
        flash[:notice] = "User does not exist"
        redirect_to user_path(current_user) if logged_in?
        redirect_to root_path
      end
    else
      @user_bool = false
      @recipes = Recipe.all
    end
  end

  def create
    params_check
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    if !!params[:add_ingredient]
      add_ingredient
      render :new
    else
      recipe_save(@recipe)
    end
  end

  def show
  end

  def edit
    authorize(@recipe)
  end
    
  def update
    authorize(@recipe)
    if !!params[:add_ingredient]
      add_ingredient
      render :edit
    else
      recipe_save(@recipe)
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

    def recipe_save(recipe)
      if !recipe.user || recipe.user == current_user
        recipe.user ||= current_user
        recipe.save
        flash[:notice] = "Recipe successfully submitted"
        redirect_to recipe_path(recipe)
      else
        flash[:alert] = "Users can only save their own recipes"
        redirect_to user_path(current_user)
      end
    end

    def params_check
      if !!params[:user_id]
        if params[:user_id].to_i != current_user.id
          flash[:alert] = "You are not authorized to do that"
          redirect_to user_path(current_user)
        end
      end
    end

end
