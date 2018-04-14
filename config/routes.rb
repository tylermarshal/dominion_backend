Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
			post '/friends', to: 'friends#create'
			delete '/friends', to: 'friends#delete'
			post '/signup', to: 'players#create'
			get '/login', to: 'players#show'
			get '/players', to: 'players#index'
      post '/games', to: 'games#create'
      get '/games/:id', to: 'games#show'
      post '/games/:id/turns', to: 'turns#create'
    end
  end
end
