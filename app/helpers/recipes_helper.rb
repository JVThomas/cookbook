module RecipesHelper
  def display_index_links(recipe,user_bool)
    if user_bool
      link_to "#{recipe.name}", user_recipe_path((recipe.user),recipe)
    else
      link_to "#{recipe.name}", recipe_path(recipe)
    end
  end
end
