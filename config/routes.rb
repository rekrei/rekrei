# require 'sidekiq/web'
Projectmosul::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # authenticate :user, lambda { |u| u.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  #API
  namespace :api, defaults: {format: 'json'},
                            constraints: { subdomain: ['api', 'api.staging'] },
                            path: '/' do

    root 'base#index'
    scope module: :v1,
                  constraints: ApiConstraints.new(version: 1, default: false) do
      resources :images, only: [:index, :show]
      resources :artefacts, only: [:index, :show]
    end

    scope module: :v2,
                  constraints: ApiConstraints.new(version: 2, default: true) do
      resources :images, only: [:index, :show]
      resources :reconstructions, only: [:index, :show]
      resources :locations, only: [:index, :show]
    end
  end

  resources :donations, only: [:new, :create]


  resources :locations do
    resources :images
    resources :reconstructions do
      resources :assets
      resources :sketchfabs
    end
    resources :flickr_photos, only: [:index]
  end

  resources :reconstructions, only: [] do
    resources :sketchfabs, only: [:new, :create]
    resources :asset_relations, only: [:create]
  end

  resources :asset_relations, only: [:destroy]

  resources :artefacts, only: [:show, :index]

  resources :images, only: [:show, :index]

  root 'pages#home'
  get 'home', to: 'pages#home', as: 'home'
  get 'gallery', to: 'pages#gallery', as: 'gallery'
  get 'press', to: 'pages#press', as: 'press'
  get 'about', to: 'pages#about', as: 'about'
  get 'dashboard', to: 'dashboard#show', as: 'dashboard'
  get 'check', to: 'pages#check', as: 'check'
  get '/contact', to: 'pages#contact', as: 'contact'
  get 'flickr_connect', to: 'flickr#create', as: 'create_flickr_connection'
  get 'flickr_callback', to: 'flickr#callback', as: 'flickr_callback'
  post '/emailconfirmation', to: 'pages#email', as: 'email_confirmation'
  get 'donate', to: 'donations#new', as: 'donate'

  devise_for :users

  # namespace :admin do
  #   root "base#index"
  #   resources :users

  # end
  get '*unmatched_route', to: 'application#not_found'

end
