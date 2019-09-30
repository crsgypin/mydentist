class Admin::LinebotController < Admin::ApplicationController
	include Linebot::Clinics::Webhook::Handler

	def new
		@clinic = Clinic.first
	end

	def create
		@clinic = Clinic.find_by(friendly_id: params[:clinic_id])
		handle_messages(params["events"])
	end

	def reply_message(data)
		@data = {
			reply_message: convert_reply_message(data),
			line_account: @line_account.attributes,
		}
	end

end