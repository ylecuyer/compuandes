Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'users/:id/vcard', to: 'users#vcard', as: 'user_vcard'
  get 'users/map/(:region)', to: 'users#map', as: 'users_map', constraints: { region: /NA|SA|EU|OC|AS|AF/ }
  get 'users/country/:region', to: 'users#country', as: 'users_country'
  get 'users/search', to: 'users#search', as: 'users_search'
  resources :users, except: :create

  get 'services', to: 'static#services', as: 'services'

  resources :wizard

  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
    end

    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end
  end

end
