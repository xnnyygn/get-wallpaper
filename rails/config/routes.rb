Rails.application.routes.draw do

  get 'register' => 'users#new'
  post 'register' => 'users#create'

  get 'login' => 'session#new'
  post 'login' => 'session#create'
  delete 'logout' => 'session#destroy'

  get 'wallpapers/index'
  get 'wallpapers/list'

  get 'wallpapers/list/recommend' => 'wallpapers#list_recommend'
  get 'wallpapers/list/latest' => 'wallpapers#list_latest'
  get 'wallpapers/list/popular' => 'wallpapers#list_popular'
  get 'wallpapers/list/category/:category_id' => 'wallpapers#list_category', as: 'wallpapers_list_category'

  get 'wallpapers/:id/thumbnail' => 'wallpapers#thumbnail', as: 'wallpaper_thumbnail'
  get 'wallpapers/:id/download_dialog' => 'wallpapers#download_dialog', as: 'wallpaper_download_dialog'
  get 'wallpapers/:id/download/:width/:height' => 'wallpapers#download', as: 'wallpaper_download'

  root 'wallpapers#index'

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
end
