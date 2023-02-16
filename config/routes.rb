Rails.application.routes.draw do
  resources :posts do
    match '/scrape', to: 'posts#scrape', via: :post, on: :collection
  end
  root 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
