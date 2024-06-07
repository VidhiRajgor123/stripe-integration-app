Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :orders, only: [:new, :create] do
    get 'success', on: :member
    get 'failure', on: :member
  end
  root "home#index"
  get 'generate_images/generate', to: 'generate_images#generate'
  get 'generate_images/show', to: 'generate_images#show_image', as: 'show_image'
end
