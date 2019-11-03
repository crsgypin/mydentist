class ::Clinics::Doctors::ApplicationController < ::Clinics::ApplicationController
	before_action -> {@doctor_sidemenu = 1 }
	before_action :set_doctor

	def set_doctor
		@doctor = @clinic.doctors.find_by!(id: params[:doctor_id])
	end
 
end