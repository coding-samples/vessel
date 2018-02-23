Rails.application.routes.draw do

  namespace :api, default: { format: :json } do
    resources :issues, only: [:index, :create, :update, :destroy] do
      member do
        post :check_in
        post :check_out
        post :update_status
      end
    end
    resources :users, only: [] do
      collection do
        post :sign_in
      end
    end
  end

  get '/(*tail)', to: 'welcome#index'
end
