class ::Clinics::Patients::ApplicationController < ::Clinics::ApplicationController
	before_action :set_patient

	def set_patient
		@patient = @clinic.patients.find_by(id: params[:patient_id])
	end

end

