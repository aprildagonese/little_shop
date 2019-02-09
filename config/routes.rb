Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
root 'welcome#index'

namespace :admin do
	resources :users, only: [:index]
	resources :items, only: [:index, :edit]
end
namespace :merchant do
	resources :users, only: [:index]
  resources :items, only: [:index, :edit]
end
namespace :registered do
	resources :users, only: [:index]
  resources :items, only: [:index]

end
namespace :visitor do
	resources :users, only: [:index, :show, :new]
  resources :items, only: [:index]
end

resources :carts, only: [:create]

get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'
get '/dashboard', to: 'merchant/user#show'
get '/profile', to: 'user#show'
get '/profile/orders', to: 'user/orders#index'
get '/profile/orders/:id', to: 'user/orders#show'

end
