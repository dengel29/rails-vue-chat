Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "chats#index"

  get "/chats" => "chats#index", as: :chats_path

  resources :chats, only: [:show, :index]
end
