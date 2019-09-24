Rails.application.routes.draw do
  devise_for :members
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :main do 

  end

  namespace :linebot do
    post "webhook", to: "webhook#create"
    resources :events	  	
  end

  namespace :admin do
  	resources :clinics
  	resources :doctors
  	resources :members
  	resources :events
  	resources :patients
  	resources :services
  end

end
