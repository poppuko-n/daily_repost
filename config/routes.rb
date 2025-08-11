Rails.application.routes.draw do
  devise_for :users
  
  # ルート
  root "daily_reports#index"
  
  # タイムライン
  get "timeline", to: "timeline#index"
  
  # 日報管理
  resources :daily_reports
  
  # ユーザー管理
  resources :users, only: [:index, :show] do
    member do
      post :follow
      delete :follow, action: :unfollow
      get :followers
      get :following
    end
  end
  
  # プロフィール管理
  resource :profile, only: [:edit, :update]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
