class ::Clinics::ClinicLine::SystemsController < ::Clinics::ClinicLine::ApplicationController

	def index
		@clinic_line_systems = @clinic.clinic_line_systems.includes(:line_template)				
	end

	def edit
		@clinic_line_system = @clinic.clinic_line_systems.find(params[:id])
		@line_template = @clinic_line_system.line_template
	end

	def update
		@clinic_line_system = @clinic.clinic_line_systems.find(params[:id])
		@line_template = @clinic_line_system.line_template
		update_line_template
	end

end