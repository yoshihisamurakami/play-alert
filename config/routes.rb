Rails.application.routes.draw do
  #get 'users/create'

  root 'stages#index'
  resources :stages
  post 'users/create', to: 'users#create'
end
