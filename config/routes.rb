Rails.application.routes.draw do
  root 'stages#thisweek'
  
  get 'stages/playing',  to: 'stages#playing'
  get 'stages/thisweek', to: 'stages#thisweek'
  get 'stages/later',    to: 'stages#later'
  get 'stages/detail/:id', to: 'stages#detail'
  resources :stages, only: [:show]
  
  get 'stages/json/playing',  to: 'stages_json#playing'
  get 'stages/json/thisweek', to: 'stages_json#thisweek'
  get 'stages/json/later',    to: 'stages_json#later'
  
  post 'alerts/create', to: 'alerts#create'
  get 'help', to: 'static_pages#help'
  get 'calendar', to: 'calendar#index'
  get 'stars/set/:id', to: 'stars#set'
  get 'stars/unset/:id', to: 'stars#unset'
  get 'signup', to: 'users#new'
  post 'signup',  to: 'users#create'
  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'
  resources :users

  get 'stage_search/', to: 'stage_search#index'
  post 'stage_search/', to: 'stage_search#search'
  
  get  'contact',         to: 'contacts#index'
  post 'contact/confirm', to: 'contacts#confirm'
  post 'contact/sent',    to: 'contacts#sent'
  
  post 'area/set',        to: 'area#create'
  
  resources :password_resets, only: [:new, :create, :edit, :update]
end
