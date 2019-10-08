class Clinics::ApplicationController < ApplicationController
	layout 'clinics'
	before_action :set_clinic
  include JsCrudConcern

	def set_clinic
		@clinic = Clinic.find_by(friendly_id: params[:clinic_id])
	end

end