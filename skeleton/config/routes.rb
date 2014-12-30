NewsReader::Application.routes.draw do


  namespace :api do
    resources :feeds, only: [:index, :create, :show, :destroy, :new] do
      resources :entries, only: [:index]

      member do
        post 'favorite'
      end
    end

    resources :users, only: [:new, :create, :show]

  end

  root to: "static_pages#index"
  resource :session, only: [:new, :create, :destroy]
end
