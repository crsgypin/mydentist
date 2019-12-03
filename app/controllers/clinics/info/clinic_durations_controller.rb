class ::Clinics::Info::ClinicDurationsController < ::Clinics::Info::ApplicationController

	def index
		@clinic_durations = @clinic.clinic_durations
		@clinic_holiday_categories = @clinic.clinic_holiday_categories
	end

	def create
    ActiveRecord::Base.transaction do	
    	#clinic duration
			@clinic_durations = @clinic.clinic_durations
			@clinic_durations.destroy_all
			params[:clinic_durations].each do |clinic_duration|
				@clinic.clinic_durations.create!(wday_hour_minute: clinic_duration[:wday_hour_minute], duration: Clinic.default_duration)
			end

			#clinic holidays
			@clinic.clinic_holiday_categories.destroy_all
			params[:clinic_holiday_categories].each do |category|
				@clinic.clinic_holiday_categories.create(category: category)
			end
			Clinic::Holiday.reload_clinic_holidays(@clinic)

			#update note
			@clinic.update_clinic_durations_note!
		end
	end

	private

	def clinic_duration_params
		params.require(:clinic_duration).permit(:wday_hour_minute)		
	end

end

