class LinebotWebhook::Controllers::DoctorsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::Doctors

	def index
		@doctors = @clinic.doctors
		reply_doctors
	end

	def show
		@doctor = @clinic.doctors.find_by(id: params[:doctor_id])
		reply_doctor
	end

end

