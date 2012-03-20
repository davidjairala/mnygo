Mnygo::Application.routes.draw do
  # Reports
  match 'companies/reports/monthly_profits/:company_id' => 'reports#monthly_profits'
  match 'companies/reports/profits/:company_id' => 'reports#profits'
  match 'companies/reports/view_monthly_divisions/:company_id/:division_id' => 'reports#report_view_monthly_divisions'
  match 'companies/reports/monthly_divisions/:company_id' => 'reports#report_monthly_divisions'
  match 'companies/reports/divisions/:company_id' => 'reports#report_divisions'
  match 'companies/reports/view_monthly_locations/:company_id/:location_id' => 'reports#report_view_monthly_locations'
  match 'companies/reports/monthly_locations/:company_id' => 'reports#report_monthly_locations'
  match 'companies/reports/locations/:company_id' => 'reports#report_locations'
  match 'companies/reports/view_monthly_customers/:company_id/:customer_id' => 'reports#report_view_monthly_customers'
  match 'companies/reports/monthly_customers/:company_id' => 'reports#report_monthly_customers'
  match 'companies/reports/customers/:company_id' => 'reports#report_customers'
  match 'companies/reports/view_monthly_products/:company_id/:product_id' => 'reports#report_view_monthly_products'
  match 'companies/reports/monthly_products/:company_id' => 'reports#report_monthly_products'
  match 'companies/reports/products/:company_id' => 'reports#report_products'
  match 'companies/reports/view_monthly_sellers/:company_id/:user_id' => 'reports#report_view_monthly_sellers'
  match 'companies/reports/monthly_sellers/:company_id' => 'reports#report_monthly_sellers'
  match 'companies/reports/sellers/:company_id' => 'reports#report_sellers'
  match 'companies/reports/monthly_sales/:company_id' => 'reports#report_monthly_sales'
  match 'companies/reports/sales/:company_id' => 'reports#report_sales'
  match 'companies/reports/:company_id' => 'reports#reports'

  # Company users
  match 'company_users/ac_users' => 'company_users#ac_users'
  match 'company_users/new/:company_id' => 'company_users#new'
  match 'companies/company_users/:company_id' => 'company_users#list_users'
  resources :company_users

  # Invoices
  match 'invoice/add_kit/:company_id' => 'invoices#add_kit'
  match 'invoices/list_items/:company_id' => 'invoices#list_items'
  match 'invoices/ac_kit/:company_id' => 'invoices#ac_kit'
  match 'invoices/ac_products/:company_id' => 'invoices#ac_products'
  match 'invoices/ac_user/:company_id' => 'invoices#ac_user'
  match 'invoices/ac_customers/:company_id' => 'invoices#ac_customers'
  match 'invoices/new/:company_id' => 'invoices#new'
  match 'invoices/do_email/:id' => 'invoices#do_email'
  match 'invoices/do_process/:id' => 'invoices#do_process'
  match 'invoices/email/:id' => 'invoices#email'
  match 'invoices/pdf/:id' => 'invoices#pdf'
  match 'companies/invoices/:company_id' => 'invoices#list_invoices'
  resources :invoices

  # Customers
  match 'customers/create_ajax/:company_id' => 'customers#create_ajax'
  match 'customers/new/:company_id' => 'customers#new'
  match 'companies/customers/:company_id' => 'customers#list_customers'
  resources :customers

  # Divisions
  match 'divisions/new/:company_id' => 'divisions#new'
  match 'companies/divisions/:company_id' => 'divisions#list_divisions'
  resources :divisions

  # Restocks
  match 'restocks/process/:id' => 'restocks#do_process'
  match 'restocks/new/:company_id/:product_id' => 'restocks#new'
  match 'companies/restocks/:company_id/:product_id' => 'restocks#list_restocks'
  resources :restocks

  # Products kits
  match 'products_kits/list_items/:company_id' => 'products_kits#list_items'
  match 'products_kits/new/:company_id' => 'products_kits#new'
  match 'companies/products_kits/:company_id' => 'products_kits#list_products_kits'
  resources :products_kits

  # Products Categories
  match 'products_categories/new/:company_id' => 'products_categories#new'
  match 'companies/products_categories/:company_id' => 'products_categories#list_products_categories'
  resources :products_categories

  # Products
  match 'products/ac_products/:company_id' => 'products#ac_products'
  match 'products/ac_categories/:company_id' => 'products#ac_categories'
  match 'products/new/:company_id' => 'products#new'
  match 'companies/products/:company_id' => 'products#list_products'
  resources :products

  # Suppliers
  match 'suppliers/new/:company_id' => 'suppliers#new'
  match 'companies/suppliers/:company_id' => 'suppliers#list_suppliers'
  resources :suppliers

  # Locations
  match 'locations/new/:company_id' => 'locations#new'
  match 'companies/locations/:company_id' => 'locations#list_locations'
  resources :locations
  
  # Companies
  match 'companies/export/:id' => 'companies#export'
  resources :companies

  # Users packages
  resources :users_packages

  # Packages
  match 'payment/:slug' => 'packages#payment'
  match 'pricing/:slug' => 'packages#pick_package'
  match 'pricing' => 'packages#pricing'
  resources :packages

  # Pages
  match 'p/:page_name' => 'pages#name_clean'
  match 'err_not_found' => 'pages#err_not_found'
  match 'quick_upload' => 'pages#quick_upload'
  resources :pages

  # Users
  match 'err_perms' => 'users#err_perms'
  match 'register' => 'users#register'
  match 'logout' => 'users#logout'
  match 'login' => 'users#login'
  resources :users
  
  # Sessions
  resources :sessions
  
  # Frontpage
  match 'dashboard' => 'pages#dashboard'
  root :to => "pages#frontpage"
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
