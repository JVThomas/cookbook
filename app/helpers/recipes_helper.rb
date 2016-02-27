module RecipesHelper
  def display_index_links(recipe)
    if !!@user
      link_to "#{recipe.name}", user_recipe_path(@user,recipe)
    else
      link_to "#{recipe.name}", recipe_path(recipe)
    end
  end

  def display_header(user)
    if !!@user
      "Recipes by #{@user.name}"
    else
      "Recipes Index"
    end
  end
end
