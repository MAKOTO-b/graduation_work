Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }

  root 'top#index'

  resources :home, only: [:index]
  resources :chat_rooms, only: [:create, :show]
  resources :matching, only: [:index]
  resources :rmd_chat_rooms, only: [:create, :show]

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
