class ::Clinics::ClinicDurationsController < ::Clinics::ApplicationController

	def index
		@clinic_durations = @clinic.clinic_durations
	end

end

