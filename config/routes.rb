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

  resources :locations do
    resources :images
    resources :reconstructions do
      resources :assets
      resources :sketchfabs
    end
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
  get '/contact', to: 'pages#contact', as: 'contact'
  get '/kathmandu', :to => redirect('/kathmandu.html')
  post '/emailconfirmation', to: 'pages#email', as: 'email_confirmation'

  devise_for :users

  # namespace :admin do
  #   root "base#index"
  #   resources :users

  # end
end
