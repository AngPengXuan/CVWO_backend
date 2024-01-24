Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      #get 'post_rating/create'
      get 'posts/index'
      # post 'post_rating/create'#, to: 'post_rating#display'
      post 'posts/create'
      post 'comments/create'
      post 'show/:id', to: 'posts#show'
      delete 'destroy/:id', to: 'posts#destroy'
      delete 'comment/destroy', to: 'comments#destroy'
      patch 'update/:id', to: 'posts#update'
      patch 'comment/update', to: 'comments#update'
      patch 'post_rating/update', to: 'post_rating#update'
      post 'post_rating/show', to: 'post_rating#show'
      patch 'comment_rating/update', to: 'comment_rating#update'
      post 'comment_rating/show', to: 'comment_rating#show'
      # post 'post_rating/show_all', to: 'post_rating#show_all'
    end
  end
  post '/login', to: 'authentication#create'
  delete '/logout', to: 'authentication#destroy'
  post '/register', to: 'users#create'
  post '/validate_token', to: 'authentication#validate'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "application#index"
end
