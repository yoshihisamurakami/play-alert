Rails.application.routes.draw do

  root 'stages#index'
  resources :stages
  post 'alerts/create', to: 'alerts#create'
  get 'help', to: 'static_pages#help'
  get 'calendar', to: 'calendar#index'
end
