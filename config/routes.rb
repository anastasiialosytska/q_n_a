Rails.application.routes.draw do
  devise_for :users
  
  root to: "questions#index"

  resources :questions do
    get :delete_attachment, on: :member
    resources :answers, shallow: true do
      get :update_to_best_answer, on: :member
      get :delete_attachment, on: :member
    end
  end
end
