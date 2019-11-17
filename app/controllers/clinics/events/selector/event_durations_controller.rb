class ::Clinics::Events::Selector::EventDurationsController < ::Clinics::ApplicationController
	include Common::DateTimeDurationHelper

	def index
    @doctor_id = params[:doctor_id]
    @date = Date.parse(params[:date]) rescue Date.today
    @hour = params[:hour]
    @minute = params[:minute]
    @duration = params[:duration]

    @doctor = @clinic.doctors.find(params[:doctor_id])
    @clinic_wday_hours = @clinic.max_min_hours
    sunday = @date - @date.wday.day
    @doctor_week_hour_events = (0..6).map do |wday|
      date = (sunday + wday.day)
      r = {
        date: date,
        ch_wday: ch_wday(wday),
        hour_segments:  @doctor.day_hour_events(date, @clinic_wday_hours)
      }
    end
	end

	def create
		@doctor_id = params[:doctor_id]
    @date = Date.parse(params[:date]) rescue Date.today
    @hour = params[:hour].to_i
    @minute = params[:minute].to_i
    @duration = params[:duration].to_i
	end

end

