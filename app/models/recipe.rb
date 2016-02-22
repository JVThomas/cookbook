class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  
  belongs_to :user
  has_many :comments
  
  validates :content, presence: true
  validates :name, presence: true
end
