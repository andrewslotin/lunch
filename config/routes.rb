Lunch::Application.routes.draw do
  root to: "places#index"

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy'
end
