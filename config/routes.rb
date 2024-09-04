Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :patients, only: [ :create ] do
        resources :injections, only: [ :index, :create ]
        get "adherence_score", to: "adherence_scores#show", as: "adherence_score"
      end
    end
  end
end
