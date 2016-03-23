Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Simple "Hello, World" page
  root 'application#index'

  # This URL is used for health checks
  get 'health' => 'application#health'
end
