Rails.application.routes.draw do
  post 'mentions/create' => 'meitons#create'
  get 'mentions/destroy'=> 'meitons#destroy'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books do
    scope module: :books do
      resources :comments, only: :create
    end
  end
  resources :reports do
    scope module: :reports do
      resources :comments, only: :create
    end
  end
  resources :comments, only: :destroy
  resources :users, only: %i(index show)
end
