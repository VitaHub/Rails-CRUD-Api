Rails.application.routes.draw do
  get 'sessions/new'

  root 'main#index'
  get 'signup' => 'users#new'
  resources :users

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

    #api
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :show, :update, :destroy]
      resources :sessions, only: [:create]
    end
  end
end
