class ::Clinics::ClinicLine::LineTemplateMessagesController < ::Clinics::ClinicLine::ApplicationController

	def destroy
		@line_template_message = Line::TemplateMessage.find(params[:id])
		if !@line_template_message.destroy
			return js_render_error "移除失敗"
		end
	end

end