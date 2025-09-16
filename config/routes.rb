Rails.application.routes.draw do
  get 'visits/create'
  root 'homes#top'

  # セッション関連
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # ユーザー登録用パス
  get  '/signup', to: 'users#new',    as: 'new_user'
  post '/signup', to: 'users#create', as: 'users'

  # 単独リソース
  get '/contact', to: 'contacts#new'

# 店舗
resources :stores, only: [:index, :show] do
  member do
    post 'visit', to: 'visits#create'
    get 'interior_images'
    get 'exterior_images'
    get 'food_images'
    get 'menu_images'
  end

  # ✅ コメントを店舗にネスト
  resources :comments, only: [:create]
end

# コメントに対するgood/badは個別
resources :comments, only: [] do
  member do
    post 'good'
    post 'bad'
  end
end


  # ユーザー関連
  resources :users, only: [:show, :new, :create, :edit, :update] do
    get :followers,        on: :member
    get :follows,          on: :member
    get :visits,           on: :member
    get :comments,         on: :member
    get :applications,     on: :member
    get :favorite_stores,  on: :member
    get :withdraw,         on: :member
    patch :deactivate,     on: :member
  end

  # 投稿
  resources :posts, only: [:new, :create] do
    collection do
      post :confirm
      post :complete
    end
  end

  # 通知・フォロワー一覧
  resources :notifications, only: [:index]
  resources :followers, only: [:index]
end
