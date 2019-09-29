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
			line_account: @line_account.inspect.to_json,
			reply_message: data
		}
	end

end