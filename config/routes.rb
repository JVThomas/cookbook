Rails.application.routes.draw do
  resources :comments
  resources :recipes
  resources :ingredients
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users, only: [:show] do
    resources :recipes 
    resources :comments, only:[:index, :show, :edit, :update, :delete]
  end  
  
  get '/', to: 'welcome#home', as: :home
  root 'welcome#home'
end
