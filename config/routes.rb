Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'

  resources :posts do
    resources :comments, only: [:create]
    #resources :likes, only: [:create, :destroy]
  end

  resources :users, only: [:show]

  post   '/like/:post_id' => 'likes#create',   as: 'create'
  delete '/like/:post_id' => 'likes#destroy', as: 'destroy'
end
