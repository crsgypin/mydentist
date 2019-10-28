class ::Clinics::ClinicLine::SystemsController < ::Clinics::ClinicLine::ApplicationController

	def index
		@clinic_line_systems = @clinic.clinic_line_systems.includes(:line_template)				
	end

end