Rails.application.routes.draw do

root 'welcome#index', as: "welcome"
get '/register', to: 'users#new'
get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'

resources :items, only: [:index, :new, :create, :destroy, :show], param: :slug
patch '/items/:slug/enable', to: "items#enable", as: 'enable_item'

get '/cart', to: 'carts#show'
post '/cart', to: 'carts#create', as: 'carts'
patch '/cart', to: 'carts#update'
delete '/cart', to: 'carts#destroy'
post '/cart/delete_item', to: 'carts#delete_item'

#------------User---------------
get '/profile', to: 'users#show'
get '/profile/edit', to: 'users#edit'
put '/profile', to: 'users#update'

get '/profile/orders', to: 'users/orders#index'
patch '/profile/orders', to: 'users/orders#update'
delete '/profile/orders', to: 'users/orders#destroy'
get '/profile/orders/:slug', to: 'users/orders#show', as: 'profile_order'

resources :users, only: [:create, :update] do
  resources :orders, only: [:show, :create]
end

#------------Merchant-------------
get '/dashboard', to: 'merchants#show'
get '/dashboard/items', to: 'merchants/items#index'
get '/dashboard/items/new', to: 'items#new'
get '/dashboard/items/:slug/edit', to: 'merchants/items#edit', as: 'dashboard_item_edit'
patch '/dashboard/items', to: 'merchants/items#update'
get '/dashboard/orders/:slug', to: 'merchants/orders#show', as: 'dashboard_order'
patch '/dashboard/orderitems/:slug', to: 'merchants/order_items#update', as: 'dashboard_order_item'
resources :merchants, only: [:index]

#--------------Admin---------------
get '/admin/dashboard', to: 'admin/dashboard#show'
patch '/admin/downgrade', to: 'admin/merchants#downgrade'
patch '/admin/upgrade', to: 'admin/users#upgrade'
patch '/admin/activation', to: 'admin/users#activation'
get '/admin/merchants/orders', to: 'merchants/orders#show', as: 'admin_merchant_order'
patch '/admin/merchants/orderitems', to: 'merchants/order_items#update', as: 'admin_merchant_order_item'
namespace :admin do
  resources :merchants, only: [:index, :show, :update], param: :slug
  resources :items, except: [:show], param: :slug
  resources :users, only: [:index, :show, :edit, :update], param: :slug
  resources :orders, only: [:index, :show, :destroy]
end

end
