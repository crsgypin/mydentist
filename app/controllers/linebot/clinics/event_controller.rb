class Linebot::Clinics::EventController < Linebot::Clinics::ApplicationController

	def show
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@booking_event = @line_account.events.find_or_initialize_by(status: "預約中")

		@doctor = @clinic.doctors.find_by(id: params[:doctor_id]) || @clinic.doctors.first

		@date = Date.parse(params[:date]) rescue Date.today
		@doctor_durations = @doctor.doctor_durations.where(wday: @date.wday)
		@doctor_events = @doctor.events.where(date: @date).includes(:events)
		@doctor_event_durations = @doctor.event_durations.where("events.date = ?", @date)
		respond_to do |format|
			format.html
			format.js
		end
	end

	def update
		if !params[:event][:hour_minute].present?
			return @error_message = "您尚未選擇時間"
		end
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@line_account.update(dialog_status: nil, dialog_status_step: nil)
		@booking_event = @line_account.events.find_or_initialize_by(status: "預約中")
		@booking_event.clinic = @clinic
		@booking_event.patient = @line_account.patient
		@booking_event.status = "已預約"
		if !@booking_event.update(event_params)
			 return @error_message = @booking_event.errors.full_messages.join("-")
		end
	end

	private

	def event_params
		params.require(:event).permit(:doctor_id, :service_id, :date, :hour_minute)
	end

end

