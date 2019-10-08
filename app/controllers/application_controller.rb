class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
	layout 'accounts', if: :devise_controller?
	include DeviseConcern

end
