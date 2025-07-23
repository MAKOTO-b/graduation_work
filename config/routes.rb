Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    registrations: "registrations",
    sessions: "sessions"
  }

  root "top#index"

  resources :home, only: [ :index ]
  resources :chat_rooms, only: [ :create, :show ]
  resources :matching, only: [ :index ]
  resources :rmd_chat_rooms, only: [ :create, :show ]

  get "up" => "rails/health#show", as: :rails_health_check

  # chatbot
  get 'bot_messages', to: 'bot_messages#index'
  post 'bot_messages', to: 'bot_messages#create'
  post 'bot_messages/clear', to: 'bot_messages#clear_session', as: 'bot_messages_clear_session'
  get 'clear_session', to: 'bot_messages#clear_session'

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # プライバシーポリシー
  get 'privacy', to: 'pages#privacy'
  # 利用規約
  get 'tos', to: 'pages#tos'
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
