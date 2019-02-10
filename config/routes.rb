Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
root 'welcome#index'


namespace :profile do
	get '', to: 'users#show'
end

namespace :dashboard do
	get '', to: 'users#show'
  resources :items, except: [:show]
end

namespace :admin do
	resources :items, except: [:show]
	resources :users, only: [:show, :index, :edit, :update]
end

get '/register', to: 'users#new'
get '/merchants', to: 'users#index'
get '/merchants/:id', to: 'users#show'
get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
delete '/logout', to: 'sessions#destroy'

get '/dashboard', to: 'merchant/user#show'
get '/profile', to: 'users#show'
#get '/profile/orders', to: 'user/orders#index'
#get '/profile/orders/:id', to: 'user/orders#show'

resources :items, only: [:show, :index, :edit]
resources :users, only: [:index, :create, :edit]

end
