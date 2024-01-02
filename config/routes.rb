Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'posts/index'
      post 'posts/create'
      post 'comments/create'
      post 'show/:id', to: 'posts#show'
      delete 'destroy/:id', to: 'posts#destroy'
      delete 'comment/destroy/:id', to: 'comments#destroy'
      patch 'update/:id', to: 'posts#update'
      patch 'comment/update/:id', to: 'comments#update'
    end
  end
  post '/login', to: 'authentication#create'
  delete '/logout', to: 'authentication#destroy'
  post '/signup', to: 'users#create'
  post '/validate_token', to: 'authentication#validate'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
