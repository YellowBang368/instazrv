Rails.application.routes.draw do
  resources :posts
  devise_for :users, :controllers => { registrations: 'registrations' }


  root "users#index"
  get "users/:id/show", to: "users#show"


end
