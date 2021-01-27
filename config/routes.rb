Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resources :users, only: [:index, :show]
  
  resources :tenants do
    get :my, on: :collection
  end
  
  resources :members do
    get :invite, on: :collection
  end
  
end
