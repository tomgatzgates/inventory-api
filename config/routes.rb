Rails.application.routes.draw do
  resources :products do
    resources :variants
  end
end
