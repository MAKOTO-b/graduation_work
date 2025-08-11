Rails.application.routes.draw do
  get "grumbles/new"
  get "grumbles/create"
  get "grumbles/index"
  devise_for :users,
  controllers: {
    registrations: "registrations",
    sessions: "sessions"
    # omniauth_callbacks: "users/omniauth_callbacks",
  }

  root "home#index"

  resources :home, only: [ :index ]
  resources :matching, only: [ :index ]
  resources :rmd_chat_rooms, only: [ :create, :show, :destroy ]
  resources :rmd_chat_messages, only: [ :create ]
  resources :users, only: [ :show, :edit, :update ]
  resources :grumbles do
    member do
      post "like"
      delete "unlike"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # chatbot
  get "bot_messages", to: "bot_messages#index"
  post "bot_messages", to: "bot_messages#create"
  post "bot_messages/clear", to: "bot_messages#clear_session", as: "bot_messages_clear_session"
  get "clear_session", to: "bot_messages#clear_session"

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # googleログイン

  # プライバシーポリシー
  get "privacy", to: "pages#privacy"
  # 利用規約
  get "tos", to: "pages#tos"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
