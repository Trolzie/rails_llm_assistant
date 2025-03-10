Rails.application.routes.draw do
  get "messages/create"
  resources :conversations do
		resources :messages, only: [:create]
	end

	root "conversations#index"
end
