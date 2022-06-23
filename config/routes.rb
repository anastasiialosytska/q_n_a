Rails.application.routes.draw do
  devise_for :users
  
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true do
      get :update_to_best_answer, on: :member
    end
  end
end
