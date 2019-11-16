class ::Clinics::Events::Lightbox::Doctors::ApplicationController < ::Clinics::ApplicationController
	before_action :set_doctor

	def set_doctor
		@doctor = @clinic.doctors.find(params[:doctor_id])
	end	

end
