UrlShortener::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#index'
# 	get 'submit' => 'static_pages#create_short_url'
# 	post 'launch' => 'static_pages#launch'
	
	resources :users, only: [:index, :new, :create, :show]
	
	resources :shortened_urls, only: [:index, :new, :create, :destroy]
	post 'launch' => 'shortened_urls#launch', as: :launch
	resources :tag_topics, only: [:index, :new, :create, :show, :destroy] 
	
# 	get 'session/new' => 'sessions#new', as: :new_session
# 	post 'session' => 'sessions#create', as: :session
# 	delete 'session' => 'sessions#destroy'
	
	resource :session, only: [:new, :create, :destroy]
	
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
end
