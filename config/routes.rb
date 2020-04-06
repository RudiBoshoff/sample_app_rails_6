Rails.application.routes.draw do
  
  get 'password_resets/new'
  get 'password_resets/edit'
  # static pages
  root 'static_pages#home'
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
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # microposts
  resources :microposts,          only: [:create, :destroy]
end
