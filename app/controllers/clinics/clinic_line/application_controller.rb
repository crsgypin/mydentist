class ::Clinics::ClinicLine::ApplicationController < ::Clinics::ApplicationController
	before_action -> {@clinic_line_sidemenu = 1 }

	private
	 
	def update_line_template
    ActiveRecord::Base.transaction do 
			@line_template.keywords.destroy_all
			@line_template.template_messages.destroy_all
			@line_template.update(line_template_params)
		end
	end

	def line_template_params
		params.require(:line_template).permit(keywords_attributes: [:name], template_messages_attributes: [:content])
	end

end

