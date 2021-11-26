Rails.application.routes.draw do

  get 'users/show'

  #get 'users/new'
  #get 'users/:id', :to => 'users#show', :as => :user
  #post 'users/create', action: :create, controller: 'users'
  #delete '/users/:id', action: :destroy, controller: 'users'
  
  
  get '/admin/index'
  post '/admin/index', action: :create, controller: 'users'
  delete '/admin/index', action: :delete_user, controller: 'admin'
  
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

  root to: "pages#home"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
