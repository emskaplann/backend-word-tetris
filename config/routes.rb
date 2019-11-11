Rails.application.routes.draw do
  resources :users, only: [:index, :create]
  resources :games, only: [:index, :create]
end
