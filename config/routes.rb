Rails.application.routes.draw do
  
  root 'static_pages#home'
  
  # static pages
  get '/help',      to: 'static_pages#help'
  get '/about',     to: 'static_pages#about'
  get '/contact',   to:'static_pages#contact'
  
  # users
  resources :users
  get '/signup',    to: 'users#new'
  
  # sessions
  get 'login',      to: 'sessions#new'
  post 'login',     to: 'sessions#create'
  delete 'logout',  to: 'sessions#destroy'
  
  # account activation
  resources :account_activations, only: [:edit]
  
  # password resets
  get 'password_resets/new'
  get 'password_resets/edit'
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # microposts
  resources :microposts,          only: [:create, :destroy]
end
