Rails.application.routes.draw do

  resources :departments
  get 'reports/annual_report'
  
  resources :notifications do
    collection do
      post :mark_as_read
    end
  end

  resources :bills do
    resource :bill_committee do
      post :sign
    end
    post 'sign', to: 'signatures#bill_create'
    post :initialize_committee_formation
  end

  resources :petitions do
    resources :petition_steps
    #post 'sign', to: 'signatures#petition_create'
    member do
      # post :start_collecting_signatures
      post :submit
    end
  end

  post 'petition_steps/:petition_id/finish', to: 'petition_steps#finish', as: :finish_wizard

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
    member do
      get :edit_password
      patch :update_password
      get :edit_phone_number
      patch :update_phone_number
      get :logs, to: 'users#logs'
    end
    collection do
      get 'admins', to: 'users#index_admins', as: 'index_admins'
      get 'officials', to: 'users#index_officials', as: 'index_officials'
      get 'new_admin', to: 'users#new_admin', as: 'new_admin'
      post 'create_admin', to: 'users#create', as: 'create_admin'
      get 'new_official', to: 'users#new_official', as: 'new_official'
      post 'create_official', to: 'users#create', as: 'create_official'
    end
  end


  namespace :officials do
    resources :bills, only: [:index, :show] do
      member do
        post :approve_committee
        post :approve_for_signatures
        post :start_collecting_signatures
        post :verify_signatures
        post :marshal_review
        post :committee_review
      end
    end

    resources :petitions, only: [:index, :show] do
      member do
        post :approve
        post :reject
        post :verify_signatures
        post :respond
        post :request_supplement
        post :forward_for_response
        get :request_supplement_form
        post :add_comment
        post :assign_to_me
        post :transfer
      end
      collection do
        post :merge_petitions
      end
    end
  end

  namespace :admin do
    resources :users, only: [:new, :create, :edit, :update, :destroy]
  end
  get 'reports/annual_report', to: 'reports#annual_report', as: 'annual_report'
end
