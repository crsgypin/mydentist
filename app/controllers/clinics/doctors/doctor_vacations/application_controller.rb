class ::Clinics::Doctors::DoctorVacations::ApplicationController < ::Clinics::Doctors::ApplicationController
	before_action :set_doctor_vacation

	def set_doctor_vacation
		@doctor_vacation = @doctor.doctor_vacations.find(params[:doctor_vacation_id])
	end
	
end