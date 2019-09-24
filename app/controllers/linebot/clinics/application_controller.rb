class Linebot::Clinics::ApplicationController < Linebot::ApplicationController
	before_action :set_clinic

	def set_clinic
		@clinic = Clinic.find_by(friendly_id: params[:clinic_id])
	end

end

