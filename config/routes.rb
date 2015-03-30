Projectmosul::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :artefacts do
    resources :assets
  end

  resources :images do
    member do
      get 'download'
    end
  end

  root "pages#home"
  get "home", to: "pages#home", as: "home"
  get "gallery", to: "pages#gallery", as: "gallery"
  get 'press', to: 'pages#press', as: "press"
  get "/contact", to: "pages#contact", as: "contact"
  post "/emailconfirmation", to: "pages#email", as: "email_confirmation"
  
  
  devise_for :users

  # namespace :admin do
  #   root "base#index"
  #   resources :users
    
  # end

end
