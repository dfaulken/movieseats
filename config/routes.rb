Rails.application.routes.draw do
  root to: 'venues#index'
  resources :venues do
    member do
      get  :test_solution
      post :test_solution
      post :update_seat
    end
  end
end
