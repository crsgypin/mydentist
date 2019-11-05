Rails.application.routes.draw do
  devise_for :members, controllers: {}, module: :accounts, path: :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :main do 

  end

  namespace :linebot do
    resources :clinics, only: [], module: :clinics do
      post "webhook", to: "webhook#create"
      resource :event, only: [:show, :create], controller: :event
      resource :doctor, only: [:show], controller: :doctor
    end
    resources :events
  end

  resources :clinics, only: [], module: :clinics do
    resources :events
    resources :patients
    resources :patients, only: [], module: :patients do
      resource :notification, only: [:create, :destroy], controller: :notification
    end
    resources :doctors
    resources :doctors, only: [], module: :doctors do
      resource :info, only: [:show, :edit, :update], controller: :info
      resource :info, only: [], module: :info do
        resource :photo, only: [:new, :create], controller: :photo
      end
      resources :doctor_durations, only: [:index, :create]
      resources :doctor_services
      resources :doctor_vacations
      resources :doctor_vacations, only: [], module: :doctor_vacations do
        resources :events, only: [:index]
        resources :vacation_notifications, only: [:index, :create]
      end
    end
    resource :info, only: [:show, :edit, :update], controller: :info
    resource :info, only: [], module: :info do
      resources :clinic_durations, only: [:index, :create]
      resources :clinic_vacations, only: [:index, :new, :create, :update, :destroy]
      resources :clinic_vacations, only: [], module: :clinic_vacations do
        resources :events, only: [:index]
        resources :vacation_notifications, only: [:index, :create]
      end
      resources :services, only: [:index, :new, :create, :destroy]
      resource :photo, only: [:new, :create], controller: :photo
    end
    namespace :clinic_line do
      resources :keywords
      resources :knowledge_categories
      resources :knowledge_categories, only: [], module: :knowledge_categories do
        resources :knowledges
      end
      resources :systems
      resources :broadcasts
    end
    resources :members
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
      resources :booking_events
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
      resources :booking_events
      resources :patients
      resources :patients, only: [], module: :patients do
        resource :info, only: [:show, :edit, :update], controller: :info
        resources :events      
      end
      resources :services
      resources :line_accounts
      resources :line_accounts, only: [], module: :line_accounts do
        resource :info, only: [:show], controller: :info
        resources :line_sendings
      end
      resource :linebot, only: [:new, :create], controller: :linebot #for linebot test
      get "styles", to: redirect("/admin/dev/style/colors")
      namespace :style do
        resources :colors, only: [:index, :show]
        resources :buttons, only: [:index, :show]
        resources :lightboxes, only: [:index, :show]
        resources :components, only: [:index, :show]
      end
    end
  end

end
