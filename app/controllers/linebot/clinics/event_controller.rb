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

	def update
		if !params[:event][:hour_minute].present?
			return @error_message = "您尚未選擇時間"
		end
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@line_account.update(dialog_status: nil, dialog_status_step: nil)
		@booking_event = @line_account.booking_events.find_or_initialize_by(status: "預約中")
		@booking_event.clinic = @clinic
		@booking_event.patient = @line_account.patient
		@booking_event.status = "已預約"
		if !@booking_event.update(event_params)
			 return @error_message = @booking_event.errors.full_messages.join("-")
		end
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
		@doctor_durations = @doctor.doctor_durations.where(wday: @date.wday)
		doctor_duration_hours = @doctor_durations.map do |doctor_duration|
			doctor_duration.hour
		end
		@doctor_event_durations = @doctor.event_durations.where("events.date = ?", @date)

		@select_event_durations = [
			{name: "上午診", hours: @clinic.wday_segment_hours(@date.wday, "早上")},
			{name: "下午診", hours: @clinic.wday_segment_hours(@date.wday, "下午")},
			{name: "晚上診", hours: @clinic.wday_segment_hours(@date.wday, "晚上")},
		].map do |segment|
			segment_durations = {
				name: segment[:name],
				hour_segments: segment[:hours].select do |hour|
					doctor_duration_hours.include?(hour)
				end.map do |hour|
					h = {
						hour: hour,
						minute_segments: (60 / Clinic.default_duration).times.map do |index|
							minute = Clinic.default_duration * index
							m = {
								minute: minute,
								enabled: proc do
									enabled = true
									enabled = false if @date < Date.today
									service_duration = @service.duration
									(service_duration / Clinic.default_duration).times.each do |index|
										hh = hour
										mm = minute + Clinic.default_duration * index
										if mm > 60
											hh += 1
											mm -= 60
										end
										if @doctor_event_durations.find{|d| d.hour == hh && d.minute == mm}
											enabled = false
										end
									end
									enabled
								end.call
							}
						end
					}
				end
			}
		end
	end

	def event_params
		params.require(:event).permit(:doctor_id, :service_id, :date, :hour_minute)
	end

end

