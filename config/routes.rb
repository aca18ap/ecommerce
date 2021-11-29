# frozen_string_literal: true

Rails.application.routes.draw do

  resources :faqs do
    member do
      get 'answer'
    end
  end
  resources :newsletters
  resources :metrics, only: [:index, :create]

  match '/403', to: 'errors#error_403', via: :all
  match '/404', to: 'errors#error_404', via: :all
  match '/422', to: 'errors#error_422', via: :all
  match '/500', to: 'errors#error_500', via: :all
  get 'users/show'
  
  namespace :admin do
    delete '/:id' => "admin/users#delete"
    resources :users

  end

  devise_for :users
  
  devise_scope :user do 
    delete '/users/sign_out' => 'devise/sessions#destroy'
    #post '/users/sign_up' => 'devise/sessions#create'
    #post '/users/new' => 'devise/sessions#new'
  end

  resources :newsletters


  match "/403", to: "errors#error_403", via: :all
  match "/404", to: "errors#error_404", via: :all
  match "/422", to: "errors#error_422", via: :all
  match "/500", to: "errors#error_500", via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :pricing_plans, to: 'pages#pricing_plans'

  root to: 'pages#home'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
