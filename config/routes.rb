Rails.application.routes.draw do
  root 'stages#index'
  resources :stages
end
