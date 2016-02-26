class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe
  validates :content, presence: true

  def comment_recipe_name
    comment.recipe.name
  end

  def comment_user_email
    comment.user.email
  end
end
