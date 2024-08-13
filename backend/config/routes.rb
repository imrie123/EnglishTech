Rails.application.routes.draw do
  get 'transcriptions/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:create] do
    collection do
      post "sign_in"
      delete "sign_out"
    end
  end

  resources :transcriptions, only: [:create]

  # Defines the root path route ("/")
  # root "posts#index"
end
