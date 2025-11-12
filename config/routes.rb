# config/routes.rb （全文置換）

Rails.application.routes.draw do
  # -----------------------------
  # 管理者用ルート
  # -----------------------------
  namespace :admin do
    root to: "dashboard#index"
    get    'login',  to: 'sessions#new'
    post   'login',  to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resources :users,    only: [:index, :show, :destroy]
    resources :stores,   only: [:index, :show, :edit, :update, :destroy]
    resources :comments, only: [:index, :destroy]
    resources :posts,    only: [:index, :show, :destroy] do
      member do
        post :approve
      end
    end
    resources :contacts,    only: [:index, :show, :destroy]
    resources :suspensions, only: [:create]
  end

  # -----------------------------
  # 一般ユーザー用ルート
  # -----------------------------
  root 'homes#top'

  # 認証
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # 会員登録
  get  '/signup', to: 'users#new', as: 'signup'
  post '/signup', to: 'users#create'

  # お問い合わせ
  get '/contact', to: 'contacts#new'

  # -----------------------------
  # フォロー・通知関連
  # -----------------------------
  resources :notifications, only: [:index, :update] do
    collection do
      post :create_follow_request
    end
    member do
      patch :approve_follow_request
      patch :reject_follow_request
    end
  end

  # -----------------------------
  # ユーザー関連
  # -----------------------------
  resources :users, only: [:show, :new, :create, :edit, :update] do
    member do
      get :followers
      get :follows
      get :visits
      get :comments
      get :applications
      get :favorite_stores
      get :withdraw
      patch :deactivate
      get :complete_withdraw
      delete :unfollow
    end
  end

  # ログイン中ユーザー用ショートカット
  get '/followers', to: redirect { |_, req|
    user_id = req.session[:user_id]
    user_id ? "/users/#{user_id}/followers" : '/login'
  }

  # -----------------------------
  # 店舗関連
  # -----------------------------
  resources :favorites, only: [:create, :destroy]

  resources :stores, only: [:index, :show] do
    post :visit, on: :member, to: 'visits#create'

    get :interior_images, on: :member
    get :exterior_images, on: :member
    get :food_images,     on: :member
    get :menu_images,     on: :member

    resources :comments, only: [:create, :destroy] do
      member do
        post :good
        post :bad
      end
    end
  end

  resources :visits, only: [:index]

  # -----------------------------
  # 通報機能
  # -----------------------------
  resources :reports, only: [:new, :create]

  # -----------------------------
  # 検索機能
  # -----------------------------
  resources :searches, only: [:index]

  # -----------------------------
  # 投稿（申請フロー）
  # -----------------------------
  resources :posts, only: [:new, :create] do
    collection do
      post  :confirm
      patch :confirm   # ← PATCH /posts/confirm も許可
    end
  end
end
