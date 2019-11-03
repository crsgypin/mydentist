class ::Clinics::Info::ServicesController < ::Clinics::Info::ApplicationController

	def index
		@services = @clinic.services
	end

	def new
		@service = @clinic.services.new
	end

	def create
		@clinic.update(service_params)
	end

	def destroy
		@service = @clinic.services.find(params[:id])
		if !@service.destroy
			return js_render_model_error @service
		end
	end

	private

	def service_params
		params.require(:clinic).permit(services_attributes: [:id, :name, :duration])
	end


end

