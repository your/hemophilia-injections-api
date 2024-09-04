Rails.application.routes.draw do
  root to: proc { [ 404, {}, [ "Not found." ] ] }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "health#show", as: :health_check

  namespace :api do
    namespace :v1 do
      resources :patients, only: [ :create ] do
        resources :injections, only: [ :index, :create ]
        get "adherence_score", to: "adherence_scores#show", as: "adherence_score"
      end
    end
  end
end
