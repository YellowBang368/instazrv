Rails.application.routes.draw do
  resources :posts
  devise_for :users, :controllers => { registrations: 'registrations' }

  root "users#feed"
  resources :users, only: [:show] do
    post "relationship", to: "users#create_relationship", on: :member
    delete "relationship", to: "users#destroy_relationship", on: :member
  end

end
