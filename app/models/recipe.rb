class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  
  belongs_to :user
  has_many :comments
  
  validates :content, presence: true
  validates :name, presence: true

  def add_ingredient(attributes)
    @ingredient = Ingredient.find_or_create_by(name:(attributes[:name].titlecase))
    self.recipe_ingredients.build(ingredient_id: @ingredient.id, quantity: attributes[:quantity]).save
  end

end
