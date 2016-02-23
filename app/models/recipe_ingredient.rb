class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient
  validates :quantity, presence: true

  def ingredient_name
    Ingredient.find(self.ingredient_id).name
  end
end
