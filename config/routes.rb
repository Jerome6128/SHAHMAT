Rails.application.routes.draw do
  devise_for :users
  get '/users' => 'competitors#index', as: :user_root
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :competitors do
    resources :messages, only: [:new, :create, :update, :destroy]
  end
  # sidekiq
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
