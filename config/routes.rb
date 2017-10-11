Rails.application.routes.draw do
  root 'stages#index'
  resources :stages
  post 'alerts/create', to: 'alerts#create'
end
