class ::Clinics::ClinicLine::LineKeywordsController < ::Clinics::ClinicLine::ApplicationController

	def destroy
		@line_keyword = Line::Keyword.find(params[:id])
		if !@line_keyword.destroy
			return js_render_error "移除失敗"
		end
	end

end

