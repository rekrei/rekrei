require 'sidekiq/web'
Projectmosul::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  #API
  namespace :api, defaults: {format: 'json'},
                            constraints: { subdomain: ['api', 'api.staging'] },
                            path: '/' do
    scope module: :v1,
                  constraints: ApiConstraints.new(version: 1, default: true) do
      root 'base#index'
      resources :images, only: [:index, :show]
      resources :artefacts, only: [:index, :show]
    end
  end

  resources :locations do
    resources :images do
      get 'download'
    end
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

  resources :images, only: [:show, :index] do
    member do
      get 'download'
    end
  end

  root 'pages#home'
  get 'home', to: 'pages#home', as: 'home'
  get 'gallery', to: 'pages#gallery', as: 'gallery'
  get 'press', to: 'pages#press', as: 'press'
  get 'dashboard', to: 'dashboard#show', as: 'dashboard'
  get '/contact', to: 'pages#contact', as: 'contact'
  post '/emailconfirmation', to: 'pages#email', as: 'email_confirmation'

  devise_for :users

  # namespace :admin do
  #   root "base#index"
  #   resources :users

  # end
end
