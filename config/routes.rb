Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index', as: "welcome"

  #merchant routes
  resources :merchants, only: [:index, :update]
  get '/dashboard', to: 'merchants#show'
  get '/dashboard/items', to: 'merchant/items#index'
  get '/merchants/:id', to: 'users#show'
  namespace :merchant do
    resources :items, except: [:show]
  end

  #item routes
  resources :items, only: [:show, :index, :edit, :new, :destroy]

  #cart routes
  get '/cart', to: 'carts#show'
  post '/cart', to: 'carts#create', as: 'carts'
  delete '/cart', to: 'carts#destroy'

  #user routes
  resources :users, only: [:show, :index, :create, :update] do
    resources :orders, only: [:show, :create]
  end
  get '/register', to: 'users#new'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  put '/profile', to: 'users#update'
  get '/profile/orders', to: 'user/orders#index'
  patch '/profile/orders', to: 'user/orders#update'
  get '/profile/orders/:id', to: 'user/orders#show'

  #admin routes
  namespace :admin do
    resources :merchants, only: [:show, :index]
    resources :items, except: [:show]
    resources :users, only: [:show, :index, :edit, :update]
  end
  get '/admin/dashboard', to: 'admin/dashboard#show'

  #login routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end
