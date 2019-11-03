class ::Clinics::Doctors::DoctorVacationsController < ::Clinics::Doctors::ApplicationController

	def index
		@doctor_vacations = @doctor.doctor_vacations
	end

	def create

	end


end