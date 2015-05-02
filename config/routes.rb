Projectmosul::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  #API
  namespace :api, defaults: {format: 'json'},
                            constraints: { subdomain: 'api' },
                            path: '/' do
    scope module: :v1,
                  constraints: ApiConstraints.new(version: 1, default: true) do
      resources :images, only: [:index, :show]
      resources :artefacts, only: [:index, :show]
    end
  end

  resources :locations do
    resources :images
    resources :reconstructions, except: [:index, :destroy] do
      resources :assets
      resources :sketchfabs
    end
  end

  resources :reconstructions do
    resources :assets, shallow: true
    resources :sketchfabs, shallow: true
  end

  resources :artefacts do
    resources :assets
    resources :sketchfabs
  end

  resources :images do
    member do
      get 'download'
    end
  end

  root 'pages#home'
  get 'home', to: 'pages#home', as: 'home'
  get 'gallery', to: 'pages#gallery', as: 'gallery'
  get 'press', to: 'pages#press', as: 'press'
  get '/contact', to: 'pages#contact', as: 'contact'
  post '/emailconfirmation', to: 'pages#email', as: 'email_confirmation'

  devise_for :users

  # namespace :admin do
  #   root "base#index"
  #   resources :users

  # end
end
