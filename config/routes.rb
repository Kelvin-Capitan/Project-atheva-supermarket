Rails.application.routes.draw do

  #Supermarket routes
  get '/supermarkets', to: 'supermarkets#list_all'
  get '/supermarkets/:id', to: 'supermarkets#list_one'
  delete '/supermarkets/:id', to: 'supermarkets#remove'

  #Categories routes
  get '/categories', to: 'categories#list_all'
  get '/categories/:id', to: 'categories#list_one'
  post '/categories/create', to: 'categories#create'
  patch '/categories/:id', to: 'categories#update'
  delete '/categories/:id', to: 'categories#delete'
  delete '/categories/remove/many', to: 'categories#remove_many'

  #Products routes
  get '/products', to: 'products#list_all'
  get '/products/:id', to: 'products#list_one'
  patch '/products/buy', to: 'products#buy'
  patch '/products/sell', to: 'products#sell'
  patch '/products/:id', to: 'products#update'
  delete '/products/:id', to: 'products#remove'
  delete '/products/remove/many', to: 'products#remove_many'

  #Extracts routes
  get '/extracts', to: 'extracts#list_all'
  get '/extracts/:id', to: 'extracts#list_one'
  get '/extracts/product/:id', to: 'extracts#list_by_product'
  get '/extracts/category/:id', to: 'extracts#list_by_category'
  get '/extracts/filter/date', to: 'extracts#list_by_date'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
