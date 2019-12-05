class LinebotWebhook::Controllers::DoctorsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::DoctorsReply

	def index
		@doctors = @clinic.doctors.form_completes
		reply_doctors
	end

	def show
		# @doctor = @clinic.doctors.find_by(id: @message[:data][:doctor_id])
		# reply_doctor
	end

end

