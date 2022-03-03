# frozen_string_literal: true

Rails.application.routes.draw do

  ## System users and accounts routes
  devise_for :customers, path: 'customer',
                         controllers: { sessions: 'customers/sessions', registrations: 'customers/registrations' }
  authenticated :customer_user do
    root to: 'customers#show', as: :authenticated_customer_root
  end
  resources :customers, path: 'customer'
  resources :customers, path: 'customer' do
    patch :unlock, on: :member
  end
  get '/customer/show'
  get '/customer/edit'

  devise_for :staffs, path: 'staff',
                      controllers: { sessions: 'staffs/sessions', registrations: 'staffs/registrations' }
  authenticated :staff, ->(u) { u.admin? } do
    root to: 'staffs#show', as: :authenticated_admin_root
  end
  namespace :admin do
    get '/users', to: '/admin/users#index'

    resources :customers, path: 'customer' do
      patch '/:id/edit', to: 'admin/customer#update'
    end

    resources :businesses, path: 'business' do
      patch '/:id/edit', to: 'admin/business#update'
    end

    resources :staffs, path: 'staff' do
      patch '/:id/edit', to: 'admin/staff#update'
    end
  end
  authenticated :staff, ->(u) { u.reporter? } do
    root to: 'staffs#show', as: :authenticated_reporter_root
  end
  resources :staffs, path: 'staff', only: %i[show edit update destroy]
  resources :staffs, path: 'staff' do
    patch :unlock, on: :member
  end
  get '/staff/show'
  get '/staff/edit'

  devise_for :businesses, path: 'business',
                          controllers: { sessions: 'businesses/sessions', registrations: 'businesses/registrations' }
  authenticated :business do
    root to: 'businesses#show', as: :authenticated_business_root
  end
  resources :businesses, path: 'business', only: %i[show edit update destroy]
  resources :businesses, path: 'business' do
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
