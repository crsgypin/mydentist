class ::Clinics::Info::ClinicVacationsController < ::Clinics::Info::ApplicationController

	def index
		@clinic_vacations = @clinic.clinic_vacations.order(id: :desc)
	end

	def new
		@clinic_vacation = @clinic.clinic_vacations.new
	end

	def create
		@clinic_vacation = @clinic.clinic_vacations.new(clinic_vacation_params)
		if !@clinic_vacation.save
			return js_render_model_error @clinic_vacation
		end
	end

	def update
		@clinic_vacation = @clinic.clinic_vacations.find(params[:id])
		if !@clinic_vacation.update(clinic_vacation_params)
			return js_render_model_error @clinic_vacation
		end
	end

	def destroy
		@clinic_vacation = @clinic.clinic_vacations.find(params[:id])
		if !@clinic_vacation.destroy
			return js_render_model_error @clinic_vacation
		end
	end


	private

	def clinic_vacation_params
		params.require(:clinic_vacation).permit(:start_date, :end_date)
	end

end

