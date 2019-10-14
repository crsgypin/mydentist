class Linebot::Clinics::DoctorController < Linebot::Clinics::ApplicationController

	def show
		@doctor = @clinic.doctors.find_by(id: params[:doctor_id])
	end

end

