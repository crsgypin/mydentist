class ::Clinics::ClinicLine::BroadcastsController < ::Clinics::ClinicLine::ApplicationController

	def index
		@clinic_line_broadcasts = @clinic.clinic_line_broadcasts.includes(:line_template)		
	end

	def new
		@clinic_line_broadcast = @clinic.clinic_line_broadcasts.new
		@line_template = @clinic_line_broadcast.build_line_template
	end

	def create
		@clinic_line_broadcast = @clinic.clinic_line_broadcasts.create(broadcast_params)
		@line_template = @clinic_line_broadcast.create_line_template
		update_line_template
	end

	def edit
		@clinic_line_broadcast = @clinic.clinic_line_broadcasts.find(params[:id])
		@line_template = @clinic_line_broadcast.line_template
	end

	def update
		@clinic_line_broadcast = @clinic.clinic_line_broadcasts.find(params[:id])
		@clinic_line_broadcast.update(broadcast_params)
		@line_template = @clinic_line_broadcast.line_template
		update_line_template
	end

	def destroy
		@clinic_line_broadcast = @clinic.clinic_line_broadcasts.find(params[:id])
		if !@clinic_line_broadcast.destroy
			return js_render_model_error(@clinic)
		end
	end

	private

	def broadcast_params
		params.require(:clinic_line_broadcast).permit(:title)
	end

end