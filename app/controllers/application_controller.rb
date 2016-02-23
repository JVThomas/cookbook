class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

    def after_sign_in_path_for(resource)
      user_path(current_user)
    end

    def after_sign_out_path_for(resource_or_scope)
      root_path
    end

    def logged_in?
      !!current_user
    end

    def require_login
      if !logged_in?
        flash[:alert] = "You must be logged in to perform any actions"
        redirect_to(root_path)
      end
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      if logged_in?  
        redirect_to user_path(current_user)  
      else
        redirect_to root_path
      end 
    end
end
