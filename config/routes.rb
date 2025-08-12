Rails.application.routes.draw do
  devise_for :users
  
  root "daily_reports#index"
  
  get "timeline", to: "timeline#index"
  
  resources :daily_reports
  
  resources :users, only: [:index, :show] do
    member do
      get :followers
      get :following
    end
  end
  
  resources :follows, only: [:create, :destroy], param: :user_id
  
  resource :profile, only: [:edit, :update], controller: 'profile'

  get "up" => "rails/health#show", as: :rails_health_check
end
