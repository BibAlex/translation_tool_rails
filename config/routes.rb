EolTranslationToolRails::Application.routes.draw do
  root :to => 'users#login'
  #pages
  match "home", :to => "pages#home"
  
  
  #users  
  match "login_attempt", :to => "users#login_attempt"
  match "login", :to => "users#login"
  match "logout", :to => "users#logout"
  match "home", :to => "pages#home"
  match "/users/index" => "users#index"
  match "/users/new" => "users#new"
  match "/users/create" => "users#create" 
  match "/users/:id/edit" => "users#edit"
  match "/users/:id/update" => "users#update"
  match "users/:id/change_profile" => "users#change_profile", :via => :get
  match "users/:id/change_profile_attempt" => "users#change_profile_attempt"
  match "users/:id/change_password", :to => "users#change_password", :via => :get
  match "users/:id/change_password_attempt", :to => "users#change_password_attempt"
  get "users/logout"
  
  #selections
  resources :selections, only: [:create, :index, :new]
    match "selections/create" => "selections#create"
    match "selections/index" => "selections#index"
    get "selections/hierarchy_tree"
    get "selections/search"
    get "selections/save_search"
    match "selections/:id/show_taxons" => "selections#show_taxons"
    match "selections/:id/delete" => "selections#delete"
  
  #taxon concepts
  match "taxon_concepts/:id/delete" => "taxon_concepts#delete" 
    
  #task distibution
  match "/task_distribution/index" => "task_distribution#index" 
  match "/task_distribution/assign_form" => "task_distribution#assign_form"
  match "/task_distribution/assign" => "task_distribution#assign"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
