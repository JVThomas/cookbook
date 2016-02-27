class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments
  
  validates :content, presence: true
  validates :name, presence: true

  def add_ingredient(attributes)
    attributes.each do |key,value|
      errors.add(key, "must be filled in") if value.blank?
    end
    if !errors.any?
      @ingredient = Ingredient.find_or_create_by(name:(attributes[:ingredient_name].downcase.titlecase))
      self.recipe_ingredients.build(ingredient_id: @ingredient.id, quantity: attributes[:ingredient_quantity]).save
    end
  end

  def user_name
    user.name
  end

  def self.search_by_ingredient(name)
    joins(:ingredients).where(ingredients:{name: name.downcase.titlecase}).group(:recipe_id)
  end

end
