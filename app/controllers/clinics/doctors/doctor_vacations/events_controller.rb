class ::Clinics::Doctors::DoctorVacations::EventsController < ::Clinics::Doctors::DoctorVacations::ApplicationController

	def index
		@events = @doctor_vacation.events
	end

end
