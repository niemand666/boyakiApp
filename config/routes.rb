Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'

  resources :posts do
    resources :comments, only: [:create]
  end

  resources :users, only: [:show]

  post '/like/:post_id', to: 'likes#create', as: 'create'
  delete '/like/:post_id', to: 'likes#destroy', as: 'destroy'
end
