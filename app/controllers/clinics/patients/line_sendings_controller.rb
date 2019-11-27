class ::Clinics::Patients::LineSendingsController < ::Clinics::Patients::ApplicationController

	def index
		@line_account = @patient.line_account
		@line_sending_messages = @line_account.sending_messages.where(message_type: ["text", "message"]).includes(:sending)
		@line_sending_messages = @line_sending_messages.last(50)
	end

end
