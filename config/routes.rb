Rails.application.routes.draw do
  resources :notifications, only: [] do
    member do
      patch :mark_as_read
    end
  end

  resources :bills do
    resource :bill_committee do
      post :sign
    end
  end
  resources :petitions do
    resources :signatures, only: [:create]
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
 
  get "/landing", to: 'main#landing', as: 'landing'
  
  
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy', as: 'logout'  

    authenticated :user do
      root 'users#dashboard', as: :authenticated_root
    end

    unauthenticated do
      root 'main#landing', as: :unauthenticated_root
    end
  end

  resources :users do
    post 'generate_keys', on: :collection
  end

  post 'users/upload_public_key', to: 'users#upload_public_key'

  namespace :officials do
    resources :petitions, only: [:index, :show] do
      member do
        patch :approve
        patch :reject
      end
    end
  end
end
