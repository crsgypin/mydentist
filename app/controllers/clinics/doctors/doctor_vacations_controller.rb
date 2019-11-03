class ::Clinics::Doctors::DoctorVacationsController < ::Clinics::Doctors::ApplicationController

	def index
		@doctor_vacations = @doctor.doctor_vacations
	end

	def new
		@doctor_vacation = @doctor.doctor_vacations.new
	end

	def create
		@doctor_vacation = @doctor.doctor_vacations.new(doctor_vacation_params)
		if !@doctor_vacation.save
			return js_render_model_error @doctor_vacation
		end
	end

	def update
		@doctor_vacation = @doctor.doctor_vacations.find(params[:id])
		if !@doctor_vacation.update(doctor_vacation_params)
			return js_render_model_error @doctor_vacation
		end
	end

	def destroy
		@doctor_vacation = @doctor.doctor_vacations.find(params[:id])
		if !@doctor_vacation.destroy
			return js_render_model_error @doctor_vacation
		end
	end


	private

	def doctor_vacation_params
		params.require(:doctor_vacation).permit(:start_date, :end_date)
	end

end