Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  mount Commontator::Engine => '/commontator'

  root "users#feed"
  get "search" => "users#search"
  get "change_avatar" => "users#change_avatar"
  resources :users, only: [:show, :edit] do
    delete "relationship", to: "users#destroy_relationship", on: :member
    post "relationship", to: "users#create_relationship", on: :member
  end

  resources :posts do
    post 'like', to: "posts#create_like", on: :member,  defaults: { format: 'js' }
    delete 'like', to: "posts#destroy_like", on: :member, defaults: { format: 'js' }
  end



end
