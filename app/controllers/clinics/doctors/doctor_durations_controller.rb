class ::Clinics::Doctors::DoctorDurationsController < ::Clinics::Doctors::ApplicationController

	def index
		@doctor_durations = @doctor.doctor_durations
	end

	def create
    ActiveRecord::Base.transaction do	
			@doctor_durations = @doctor.doctor_durations
			@doctor_durations.destroy_all
			params[:doctor_durations].each do |doctor_duration|
				@doctor.doctor_durations.create!(wday_hour_minute: doctor_duration[:wday_hour_minute])
			end
			@doctor.update_doctor_durations_note!
		end
	end

	private

	def doctor_duration_params
		params.require(:doctor_duration).permit(:wday_hour_minute)		
	end


end