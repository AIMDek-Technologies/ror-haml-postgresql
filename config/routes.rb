Rails.application.routes.draw do

  get 'home/index'

  # Session controller routes for login and logout
  post 'home/login'
  get 'home/logout'

  root 'home#index'

  # Routes for Customers(users)
  get '/customers' => 'users#index'
  get '/customers/new' => 'users#new'
  post '/customers' => 'users#create'
  get '/customers/:id' => 'users#show'
  get '/customers/edit/:id' => 'users#edit'
  patch '/customers/:id' => 'users#update'
  delete '/customers/:id' => 'users#destroy'
  get '/customers', :controller => :users, :action => :index, :page => 1

  # Routes for Bulk Uploads
  get '/bulk_uploads/customers'
  get '/bulk_uploads/credit_cards'
  get '/bulk_uploads/transactions'
  post '/bulk_uploads/upload' => 'bulk_uploads#upload'

  # Resourceful Routes
  resources :users
  resources :transactions
  resources :statements
  resources :bulk_uploads
  resources :credit_cards

  # temp route to create admin
  get '/create_admin' => 'users#create_admin'

  # Other utility routes
  get '/find_geographic/:zip_code' => 'users#find_geographic'
  get '/find_states/:country' => 'users#get_states_from_country'
  get '/find_cities/:state' => 'users#get_cities_from_state'
  post '/customers/filter' => 'users#filter_values'
  get 'credit_cards_of_user/:user_id' => 'credit_cards#user_credit_cards'
  # post '/sort' => 'datatables#sort_array'
  post '/filter' => 'datatables#sort_array'

  get '/generate_customer_id' => 'migration#generate_customer_id'

  post '/upload/file' => 'users#file_upload'

  get '/pdf' => 'statements#create_statement_template'
end
