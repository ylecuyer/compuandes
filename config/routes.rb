Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  resources :users, except: :create
  get 'users/:id/vcard', to: 'users#vcard', as: 'user_vcard'
  post 'users', to: 'users#search', as: 'users_search'

  root to: 'users#index'

end
