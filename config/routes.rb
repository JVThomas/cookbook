Rails.application.routes.draw do
  resources :recipes
  resources :ingredients
  resources :comments, only:[:create]
  resources :recipe_ingredients, only:[:create, :destroy]
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users, only:[:show] do
    resources :recipes 
    resources :comments, only:[:index, :show, :edit, :update, :delete]
  end  

  post '/recipes/search', to: 'recipes#search', as: :search
  
  get '/', to: 'welcome#home', as: :home
  
  root 'welcome#home'
end
