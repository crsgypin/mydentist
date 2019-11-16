class ::Clinics::Events::Lightbox::Doctors::EventsController < ::Clinics::Events::Lightbox::Doctors::ApplicationController
	include Common::DateTimeDurationHelper

	def index
		@date = Date.parse(params[:date])	rescue Date.today
		sunday = @date - @date.wday.day

		@clinic_wday_hours = @clinic.max_min_hours
		@doctor_week_hour_events = (0..6).map do |wday|
			date = (sunday + wday.day)
			r = {
				date: date,
				ch_wday: ch_wday(wday),
				day_hour_events: 	@doctor.day_hour_events(date, @clinic.wday_hours(@clinic_wday_hours))
			}
		end
	end

end

