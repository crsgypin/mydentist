class ::Clinics::Doctors::DoctorServicesController < ::Clinics::Doctors::ApplicationController

	def index
		@doctor_services = @doctor.doctor_services
	end

	def new
		@doctor_service = @doctor.doctor_services.new
	end

	def create
		@doctor.update!(doctor_params)
	end

	def update
		@doctor_service = @doctor.doctor_services.find_by!(id: params[:id])
		if !@doctor_service.update(doctor_service_params)
			@error_messages = @doctor_service.errors.full_messages.join(",")
			return js_render_error @error_messages
		end
	end

	def destroy
		@doctor_service = @doctor.doctor_services.find_by!(id: params[:id])
		if !@doctor_service.destroy
			@error_messages = @doctor_service.errors.full_messages.join(",")
			return js_render_error @error_messages
		end
	end


	private

	def doctor_service_params
		params.require(:doctor_service).permit(:service_id, :duration)
	end

	def doctor_params
		params.require(:doctor).permit(doctor_services_attributes: [:id, :service_id, :duration])
	end

end