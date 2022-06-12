Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root controller: :topics, action: :index, as: :threads

  resources :topics, only: %w[index show new create] do
    get :search, on: :collection
  end

  resources :posts, only: %w[show new create]
end
