Rails.application.routes.draw do
  devise_for :members
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :main do 

  end

  namespace :linebot do
    resources :clinics, only: [], module: :clinics do
      post "webhook", to: "webhook#create"
      resource :event, only: [:show, :update], controller: :event
    end
    resources :events	  	
  end

  namespace :admin do
  	resources :clinics
    resources :clinics, only: [], module: :clinics do
      resource :info, only: [:show, :edit, :update], controller: :info
      resources :doctors
      resources :doctors, only: [], module: :doctors do
        resource :info, only: [:show, :edit, :update], controller: :info        
        resources :doctor_durations, only: [:index, :show]
        resources :events
      end
      resources :members
      resources :services
      resources :events
      resources :patients
      resources :patients, only: [], module: :patients do
        resource :info, only: [:show, :edit, :update], controller: :info        
        resources :events
      end
    end
  	resources :doctors
    resources :doctors, only: [], module: :doctors do
      resource :info, only: [:show, :edit, :update], controller: :info
      resources :doctor_durations, only: [:index, :show]
      resources :events
    end
  	resources :members
  	resources :events
  	resources :patients
    resources :patients, only: [], module: :patients do
      resource :info, only: [:show, :edit, :update], controller: :info
      resources :events      
    end
  	resources :services
    resources :line_accounts
    resource :linebot, only: [:new, :create], controller: :linebot #for linebot test
  end

end
