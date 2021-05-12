Rails.application.routes.draw do
  resources :messages
  resources :api, only: :create
  post 'api/view'
  post 'api/view_message'
  root 'frontend#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
