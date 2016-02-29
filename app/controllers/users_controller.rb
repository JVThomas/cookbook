class UsersController < ApplicationController
  
  def show
    if User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      flash[:alert] = "User does not exist"
      home_redirect
    end
  end

end