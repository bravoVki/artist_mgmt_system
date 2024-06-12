# Rails.application.routes.draw do
#   resources :users
#   resources :artists do
#     resources :songs
#   end
#   post 'auth/login', to: 'authentication#authenticate'
# end


# Rails.application.routes.draw do
#   resources :users, only: [:index, :show, :create, :update, :destroy]
#   resources :artists do
#     resources :songs
#   end
#   post 'auth/login', to: 'authentication#authenticate'
# end

Rails.application.routes.draw do
  resources :users, only: [:index, :show, :create, :update, :destroy]
  resources :artists do
    resources :songs do
      collection do
        get :export
      end
    end
  end
  get 'songs', to: 'songs#index_all' # Use a specific name for the route
  post 'auth/login', to: 'authentication#authenticate'
  post '/register', to: 'users#register'
  post "artists/:artist_id/songs/upload", to: "songs#upload"
end
