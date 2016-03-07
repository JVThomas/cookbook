class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient
  validates :quantity, presence: true

  def ingredient_name
    self.ingredient.name if self.ingredient
  end

  def ingredient_quantity
    quanity
  end

end
