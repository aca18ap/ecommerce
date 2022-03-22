# frozen_string_literal: true

Rails.application.routes.draw do

  ## ===== System Users and Accounts Routes ===== ##
  devise_for :customers, path: 'customer',
                         controllers: { sessions: 'customers/sessions', registrations: 'customers/registrations' }
  authenticated :customer do
    root to: 'customers#show', as: :authenticated_customer_root
  end
  resources :customers, path: 'customer' do
    patch :unlock, on: :member
  end
  get '/customer/show'
  get '/customer/edit'

  devise_for :staffs, path: 'staff',
                      controllers: { sessions: 'staffs/sessions', registrations: 'staffs/registrations',
                                     invitations: 'staffs/invitations' }
  authenticated :staff, ->(u) { u.admin? } do
    root to: 'staffs#show', as: :authenticated_admin_root
  end
  namespace :admin do
    get '/users', to: '/admin/users#index'

    resources :customers, path: 'customer', only: %i[edit update destroy] do
      patch '/:id/edit', to: 'admin/customer#update'
    end

    resources :businesses, path: 'business', only: %i[edit update destroy] do
      patch '/:id/edit', to: 'admin/business#update'
    end

    resources :staffs, path: 'staff', only: %i[edit update destroy] do
      patch '/:id/edit', to: 'admin/staff#update'
    end
  end
  authenticated :staff, ->(u) { u.reporter? } do
    root to: 'staffs#show', as: :authenticated_reporter_root
  end
  resources :staffs, path: 'staff', only: %i[show edit update destroy] do
    patch :unlock, on: :member
    patch :invite, on: :member
  end
  get '/staff/show'
  get '/staff/edit'

  devise_for :businesses, path: 'business',
                          controllers: { sessions: 'businesses/sessions', registrations: 'businesses/registrations',
                                         invitations: 'businesses/invitations' }
  authenticated :business do
    root to: 'businesses#index', as: :authenticated_business_root
  end
  resources :businesses, path: 'business', only: %i[show index edit update destroy] do
    patch :unlock, on: :member
    patch :invite, on: :member
  end
  get '/business/show', to: 'businesses#index'
  get '/business/edit'

  ## ===== Reviews ===== ##
  resources :reviews
  get :review_created, to: 'reviews#created'
  
  ## ===== Products ===== ## 
  resources :products
  resources :materials

  ## ===== FAQs ===== ##
  resources :faqs do
    member do
      get 'answer'
      post 'like'
      post 'dislike'
    end
  end

  ## ===== Newsletters ===== ##
  resources :newsletters

  ## ===== Metrics ===== ##
  resources :metrics, only: %i[index create]

  ## ===== Shares ===== ##
  post 'shares', to: 'shares#create'

  ## ===== Errors ===== ##
  match '/401', to: 'errors#error_401', via: :all
  match '/403', to: 'errors#error_403', via: :all
  match '/404', to: 'errors#error_404', via: :all
  match '/422', to: 'errors#error_422', via: :all
  match '/500', to: 'errors#error_500', via: :all

  get :ie_warning, to: 'errors#ie_warning'

  ## ===== Pages ===== ##
  get :pricing_plans, to: 'pages#pricing_plans'
  get :review_usefulness, to: 'pages#review_usefulness'
  get :carbon_footprint_viewer, to: 'pages#carbon_footprint_viewer'
  get :extension_features, to: 'pages#extension_features'
  get :crowdsourced_feature, to: 'pages#crowdsourced_feature'
  get :business_info, to: 'pages#business_info'
  get :welcome, to: 'pages#welcome'
  get :thanks, to: 'pages#thanks'

  ## ===== Root ===== ##
  root to: 'pages#home'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
