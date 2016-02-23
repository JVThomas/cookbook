class RecipePolicy < ApplicationPolicy

  def edit?
    record.try(:user) == user
  end

  def update?
    record.try(:user) == user
  end

  def destroy?
    record.try(:user) == user
  end 
end