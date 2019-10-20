class ::Clinics::Doctors::DoctorServicesController < ::Clinics::Doctors::ApplicationController

	def index
		@doctor_services = @doctor.doctor_services
	end

	def new
		@doctor_service = @doctor.doctor_services.new
	end

	def create

	end


end