# -*- encoding : utf-8 -*-

Lunch::Application.routes.draw do
  root to: "places#index"

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new'
  match '/signout' => 'sessions#destroy'

  resources :places, only: [:index, :show] do
    post :vote, on: :member
    delete :vote, as: :unvote, on: :member, action: :unvote
    post :like, on: :member
    delete :like, as: :dislike, on: :member, action: :dislike
  end
end
