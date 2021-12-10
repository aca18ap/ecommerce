# frozen_string_literal: true

Rails.application.routes.draw do

  resources :reviews
  get :review_created, to: 'reviews#created'

  resources :faqs do
    member do
      get 'answer'
      post 'like'
      post 'dislike'
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
    resources :users
      patch '/:id/edit', to: 'admin/users#update'

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
  get :review_usefulness, to:'pages#review_usefulness'

  get :carbon_footprint_viewer, to: 'pages#carbon_footprint_viewer'
  get :extension_features, to: 'pages#extension_features'
  get :crowdsourced_feature, to: 'pages#crowdsourced_feature'

  get :business_info, to: 'pages#business_info'
  get :welcome, to: 'pages#welcome'
  get :thanks, to: 'pages#thanks'

  root to: 'pages#home'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
