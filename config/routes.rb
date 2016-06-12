Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  get 'users/:id/vcard', to: 'users#vcard', as: 'user_vcard'
  get 'users', to: 'users#search', as: 'users_search'
  get 'users/map/(:region)', to: 'users#map', as: 'users_map'
  resources :users, except: :create

  root to: 'users#index'

end
