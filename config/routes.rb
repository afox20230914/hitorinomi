Rails.application.routes.draw do
# -----------------------------
# 管理者用ルート
# -----------------------------
namespace :admin do
  root to: "dashboard#index" 
  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # 各管理リソース
  resources :users,    only: [:index, :show, :destroy]
  resources :stores,   only: [:index, :show, :destroy]
  resources :comments, only: [:index, :destroy]
  resources :posts,    only: [:index, :show, :destroy]
  resources :contacts, only: [:index, :show, :destroy]
  resources :suspensions, only: [:create]# アカウント停止処置用
end

  

  # -----------------------------
  # 一般ユーザー用ルート（既存）
  # -----------------------------
  root 'homes#top'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new', as: 'signup'
  post '/signup', to: 'users#create'
  get '/contact', to: 'contacts#new'

  resources :stores, only: [:index, :show] do
    member do
      post 'visit', to: 'visits#create'
      post 'favorite', to: 'favorites#create'
      delete 'unfavorite', to: 'favorites#destroy'
      get 'interior_images'
      get 'exterior_images'
      get 'food_images'
      get 'menu_images'
    end
    resources :comments, only: [:create]
  end

  resources :comments, only: [] do
    member do
      post 'good'
      post 'bad'
    end
  end

  resources :users, only: [:show, :new, :create, :edit, :update] do
    get :followers, on: :member
    get :follows, on: :member
    get :visits, on: :member
    get :comments, on: :member
    get :applications, on: :member
    get :favorite_stores, on: :member
    get :withdraw, on: :member
    patch :deactivate, on: :member
  end

  resources :searches, only: [:index]
  get '/search', to: 'searches#index', as: 'search'
  get '/users/:id/complete_withdraw', to: 'users#complete_withdraw', as: 'complete_withdraw_user'

  resources :posts, only: [:new, :create] do
    collection do
      post :confirm
      post :complete
    end
  end

  resources :notifications, only: [:index]
  resources :followers, only: [:index]
end
