class ::Clinics::Info::ClinicDurationsController < ::Clinics::ApplicationController

	def index
		@clinic_durations = @clinic.clinic_durations
	end

	def create
    ActiveRecord::Base.transaction do	
			@clinic_durations = @clinic.clinic_durations
			@clinic_durations.destroy_all
			params[:clinic_durations].each do |clinic_duration|
				@clinic.clinic_durations.create!(wday_hour_minute: clinic_duration[:wday_hour_minute], duration: Clinic.default_duration)
			end
			@clinic.update_clinic_durations_note!
		end
	end

	private

	def clinic_duration_params
		params.require(:clinic_duration).permit(:wday_hour_minute)		
	end

end

