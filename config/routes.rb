Rails.application.routes.draw do
  devise_for :admin_users
  ActiveAdmin.routes(self)
  devise_for :users, skip: [ :registrations ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Redirect root without locale to root with default locale
  get "/", to: redirect("/#{I18n.default_locale}", status: 302)

  # Locale-scoped routes
  scope "/:locale", locale: /#{I18n.available_locales.join('|')}/ do
    # Public routes — accessible to anyone
    resources :jobs, only: [ :index, :show ] do
      resources :projects, only: [ :index, :show ]
    end
    resources :educations, only: [ :index, :show ]
    resources :projects, only: [ :index ]

    root "home#index", as: :localized_root

    # Routes requiring user authentication (visitor or owner)
    authenticate :user do
      get "chat", to: "portfolio_chats#show", as: :portfolio_chat
    end

      # Routes requiring owner role
      resources :chats do
        resources :messages, only: [ :create ]
      end
      resources :models, only: [ :index, :show ] do
        collection do
          post :refresh
        end
      end
  end
end
