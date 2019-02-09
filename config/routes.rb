Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
root 'welcome'

namespace :admin do
	resources :users
	resources :items
end
namespace :merchant do
	resources :users
  resources :items
end
namespace :registered do
	resources :users
  resources :items

end
namespace :visitor do
	resources :users
  resources :items
end

get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'
get '/dashboard', to: 'merchant/user#show'
get '/profile', to: 'user#show'
get '/profile/orders', to: 'user/orders#index'
get '/profile/orders/:id', to: 'user/orders#show'

end
