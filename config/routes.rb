# frozen_string_literal: true

Rails.application.routes.draw do

  ## System users and accounts routes
  devise_for :customers, path: 'customer', controllers: { sessions: 'customers/sessions' }
  authenticated :customer_user do
    root to: "customer/dashboard#show", as: :authenticated_customer_root
  end
  resources :customers
  resources :customers do
    patch :unlock, on: :member
  end
  get '/customer/show'
  get '/customer/edit'

  devise_for :staffs, path: 'staff', controllers: { sessions: 'staffs/sessions', registrations: 'staffs/registrations' }
  authenticated :staff, ->(u) { u.admin? } do
    root to: 'staff/dashboard#show', as: :authenticated_admin_root
  end
  authenticated :staff, ->(u) { u.reporter? } do
    root to: "staff/dashboard#show", as: :authenticated_reporter_root
  end
  resources :staffs, only: %i[show edit update destroy]
  get '/staff/show'
  get '/staff/edit'

  devise_for :businesses, path: 'businesses', controllers: { sessions: 'businesses/sessions', registrations: 'businesses/registrations' }
  authenticated :business do
    root to: "business/dashboard#show", as: :authenticated_business_root
  end
  resources :businesses, only: %i[show edit update destroy]
  resources :businesses do
    patch :unlock, on: :member
  end
  get '/business/show'
  get '/business/edit'

  ## Everything else for now
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
  resources :metrics, only: %i[index create]
  post 'shares', to: 'shares#create'

  # namespace :admin do
  #   resources :users do
  #     patch '/:id/edit', to: 'admin/users#update'
  #   end
  # end

  # devise_for :users
  # devise_scope :user do
  #   delete '/users/sign_out' => 'devise/sessions#destroy'
  # end

  # resources :users do
  #   patch :unlock, on: :member
  # end
  #
  # get 'users/show'
  # get 'users/edit'

  resources :newsletters

  match '/403', to: 'errors#error_403', via: :all
  match '/404', to: 'errors#error_404', via: :all
  match '/422', to: 'errors#error_422', via: :all
  match '/500', to: 'errors#error_500', via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :pricing_plans, to: 'pages#pricing_plans'
  get :review_usefulness, to: 'pages#review_usefulness'

  get :carbon_footprint_viewer, to: 'pages#carbon_footprint_viewer'
  get :extension_features, to: 'pages#extension_features'
  get :crowdsourced_feature, to: 'pages#crowdsourced_feature'

  get :business_info, to: 'pages#business_info'
  get :welcome, to: 'pages#welcome'
  get :thanks, to: 'pages#thanks'

  root to: 'pages#home'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
