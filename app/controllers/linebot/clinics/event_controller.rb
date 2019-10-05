class Linebot::Clinics::EventController < Linebot::Clinics::ApplicationController

	def show
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@booking_event = @line_account.events.find_by(status: "預約中")

		@doctor = @clinic.doctors.find_by(id: params[:doctor_id]) || @clinic.doctors.first

		@date = Date.today + 1
		@doctor_event_durations = @doctor.doctor_durations.where(wday: @date.wday)
		@doctor_events = @doctor.events.where(date: @date)
	end

	def update
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@booking_event = @line_account.events.find_by(status: "預約中")
		if !@booking_event.update(event_params)
			 return @error_message = @booking_event.errors.full_messages.join("-")
		end
	end


	private

	def event_params
		params.require(:event).permit(:doctor_id, :service_id, :date, :hour_minute)
	end

end

