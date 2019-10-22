class Linebot::Clinics::EventController < Linebot::Clinics::ApplicationController

	def show
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@booking_event = @line_account.booking_events.last || @line_account.booking_events.new

		find_doctor
		find_service
		find_date
		set_event_durations

		respond_to do |format|
			format.html
			format.js
		end
	end

	def create
		if !params[:event][:hour_minute_duration].present?
			return @error_message = "您尚未選擇時間"
		end
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@event = @line_account.events.new
		@event.clinic = @clinic
		@event.patient = @line_account.patient
		@event.status = "已預約"
		@event.assign_attributes(event_params)
		if !@event.save
			 return js_render_error @event.errors.full_messages.join("-")
		end
		@line_account.update(dialog_status: nil, dialog_status_step: nil)
	end

	private

	def find_doctor
		if params[:doctor_id].present?
			@doctor = @clinic.doctors.find_by(id: params[:doctor_id])
		else
			@doctor = @booking_event.doctor
		end
		@doctor = @clinic.doctors.first if @doctor.nil?
	end

	def find_service
		if params[:service_id].present?
			@service = @doctor.services.find_by(id: params[:service_id])
		else
			@service = @booking_event.service
		end
		@service = @doctor.services.first if @service.nil?
	end

	def find_date
		@date = Date.parse(params[:date]) rescue Date.today
	end

	def set_event_durations
		@select_event_durations = @doctor.current_event_durations(@date, @service.duration)
	end

	def event_params
		params.require(:event).permit(:doctor_id, :service_id, :date, :hour_minute_duration)
	end

end

