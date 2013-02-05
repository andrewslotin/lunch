Lunch::Application.routes.draw do
  root to: "places#index"

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new'
  match '/signout' => 'sessions#destroy'

  resources :places, only: [:index] do
    post :vote, on: :member
    post :like, on: :member
    post :dislike, on: :member
  end
end
