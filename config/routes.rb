ContactsAPI::Application.routes.draw do

  root 'users#index'

  resources :users, only: [:index, :show, :create, :update, :destroy] do
    resources :contacts, only: [:index]
    resources :comments, only: [:index]
    resources :groups, only: [:index]
  end

  resources :contacts, only: [:show, :create, :update, :destroy] do
    resources :comments, only: [:index]
    # contacts/1/favorite => contact.owner favorites
    member do
      post 'favorite'
      delete 'unfavorite'
    end

  end

  resources :comments, only: [:create, :destroy]

  resources :groups, only: [:create, :show, :update, :destroy] do
    member do
      post "add_member"
      delete "destroy_member"
    end
  end

  resources :contact_shares, only: [:create, :destroy] do
    # contact_shares/1/favorite => contact_shares.user
    member do
      post 'favorite'
      delete 'unfavorite'
    end

  end
end

  # get 'users' => 'users#index', as: 'users'
  # get 'users/:id' => 'users#show', as: 'user'
  # get 'users/new' => 'users#new', as: 'new_user'
  # get 'users/:id/edit' => 'users#edit', as: 'edit_user'
  # post 'users' => 'users#create'
  # patch 'users/:id' => 'users#update'
  # put 'users/:id' => 'users#update'
  # delete 'users/:id' => 'users#destroy'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
