Rails.application.routes.draw do
  devise_for :users
  get '/users' => 'competitors#index', as: :user_root
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :competitors
end
