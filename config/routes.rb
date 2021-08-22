Rails.application.routes.draw do
  root to: 'venues#index'
  resources :venues do
    member do
      get  :test_solution
      post :test_solution
      post :update_seat
      post :free_sample_seat_group
    end
  end
end
