class ::Clinics::ClinicLine::KeywordsController < ::Clinics::ClinicLine::ApplicationController

	def index
		@clinic_line_keywords = @clinic.clinic_line_keywords.order(id: :desc).includes(:line_template)
	end

	def new
		@clinic_line_keyword = @clinic.clinic_line_keywords.new
		@line_template = @clinic_line_keyword.build_line_template
	end

	def create
		@clinic_line_keyword = @clinic.clinic_line_keywords.create
		@line_template = @clinic_line_keyword.create_line_template
		update_line_template
	end

	def edit
		@clinic_line_keyword = @clinic.clinic_line_keywords.find(params[:id])
		@line_template = @clinic_line_keyword.line_template
	end

	def update
		@clinic_line_keyword = @clinic.clinic_line_keywords.find(params[:id])
		@line_template = @clinic_line_keyword.line_template
		update_line_template
	end

	def destroy
		@clinic_line_keyword = @clinic.clinic_line_keywords.find(params[:id])
		if !@clinic_line_keyword.destroy
			return js_render_model_error(@clinic)
		end
	end

end
