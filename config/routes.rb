Rails.application.routes.draw do
  resources :users, only: [:index, :create]
  resources :games, only: [:index, :create]
  resources :text_data_files, only: [:create]
end
