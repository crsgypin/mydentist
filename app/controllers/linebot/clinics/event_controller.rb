class Linebot::Clinics::EventController < Linebot::Clinics::ApplicationController

	def show
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@doctor = @clinic.doctors.find_by(id: params[:doctor_id])
		@booking_event = @line_account.events.find_by(status: "預約中")
	end

	def update
		
	end

end

