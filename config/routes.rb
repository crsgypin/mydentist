Rails.application.routes.draw do
  devise_for :members, controllers: {}, module: :accounts, path: :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :main do 

  end

  namespace :linebot do
    resources :clinics, only: [], module: :clinics do
      post "webhook", to: "webhook#create"
      resource :event, only: [:show, :update], controller: :event
      resource :doctor, only: [:show], controller: :doctor
    end
    resources :events
  end

  resources :clinics, only: [], module: :clinics do
    resources :events
    resources :patients
    resources :doctors
    resources :doctors, only: [], module: :doctors do
      resource :info, only: [:show, :edit, :update], controller: :info
      resources :doctor_durations, only: [:index, :create]
      resources :doctor_services
      resources :doctor_vacations
    end
    resource :info, only: [:show, :edit, :update], controller: :info
    resource :info, only: [], module: :info do
      resources :clinic_durations, only: [:index, :create]
    end
  end

  namespace :admin do
    namespace :dentists do
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
    end
    namespace :dev do
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
      get "styles", to: redirect("/admin/dev/style/colors")
      namespace :style do
        resources :colors, only: [:index, :show]
        resources :buttons, only: [:index, :show]
        resources :lightboxes, only: [:index, :show]
      end
    end
  end

end
