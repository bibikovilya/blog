Rails.application.routes.draw do
  resources :posts, only: [:create]
  get :top, to: 'posts#top'
  resources :rates, only: [:create]
  resources :users, only: [:index]
end
