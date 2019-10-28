class ::Clinics::ClinicLine::KeywordsController < ::Clinics::ClinicLine::ApplicationController

	def index
		@clinic_line_keywords = @clinic.clinic_line_keywords.includes(:line_template)
	end

end