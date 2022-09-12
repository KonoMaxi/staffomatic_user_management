Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resource :signup, only: [ :create ]
  resources :authentications, only: [ :create ]
  resources :users, only: [ :index, :destroy ] do
    patch :archive, on: :member
  end
end
