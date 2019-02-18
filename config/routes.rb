Rails.application.routes.draw do

root 'welcome#index', as: "welcome"
get '/register', to: 'users#new'
get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'

resources :items, only: [:show, :index, :edit, :new, :destroy]

get '/cart', to: 'carts#show'
post '/cart', to: 'carts#create', as: 'carts'
patch '/cart', to: 'carts#update'
delete '/cart', to: 'carts#destroy'
post '/cart/delete_item', to: 'carts#delete_item'

#------------User---------------
get '/profile', to: 'users#show'
get '/profile/edit', to: 'users#edit'
put '/profile', to: 'users#update'
get '/profile/orders', to: 'user/orders#index'
patch '/profile/orders', to: 'user/orders#update'
get '/profile/orders/:id', to: 'user/orders#show', as: 'profile_order'
#get '/users/:id/orders', to: 'user/orders#index', as: 'user_orders'

resources :users, only: [:show, :index, :create, :update] do
  resources :orders, only: [:show, :create]
end

#------------Merchant-------------
get '/dashboard', to: 'merchants#show'
get '/dashboard/items', to: 'merchant/items#index'
# get '/merchants', to: 'users#index'
resources :merchants, only: [:index, :update]
namespace :merchant do
  resources :items, except: [:show]
end
get '/merchants/:id', to: 'users#show' #???

#--------------Admin---------------
get '/admin/dashboard', to: 'admin/dashboard#show'
namespace :admin do
  resources :merchants, only: [:show, :index]
  resources :items, except: [:show]
  resources :users, only: [:show, :index, :edit, :update]
  resources :orders, only: [:index, :show, :destroy]
end

end
