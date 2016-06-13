Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  get 'users/:id/vcard', to: 'users#vcard', as: 'user_vcard'
  get 'users/map/(:region)', to: 'users#map', as: 'users_map'
  get 'users/search', to: 'users#search', as: 'users_search'
  resources :users, except: :create

  root to: 'static#index'

end
