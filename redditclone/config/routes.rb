Rails.application.routes.draw do

  resources :users
  resource :session, only: [:new, :create, :destroy]
  resources :subs, except: [:destroy]
  resources :posts, except: [:index, :destroy] do
    resources :comments, only: [:new, :show]
    member do
      post :upvote
      post :downvote
    end
  end
  resources :comments, only: [:create] do
    member do
      post :upvote
      post :downvote
    end
  end

  root to: 'users#index'
end
