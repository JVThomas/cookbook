Rails.application.routes.draw do
  resources :recipes
  resources :ingredients
  resources :comments, only:[:create, :update]
  resources :recipe_ingredients, only:[:create, :destroy]
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users, only:[:show] do
    resources :recipes
    resources :comments, only:[:index, :show, :edit, :update, :destroy]
  end  
  
  get '/', to: 'welcome#home', as: :home
  
end
