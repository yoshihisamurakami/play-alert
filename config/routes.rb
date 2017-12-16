Rails.application.routes.draw do
  root 'stages#index'
  resources :stages, only: [:show]
  post 'alerts/create', to: 'alerts#create'
  get 'help', to: 'static_pages#help'
  get 'calendar', to: 'calendar#index'
  get 'stars/set/:id', to: 'stars#set'
  get 'stars/unset/:id', to: 'stars#unset'
end
