class ::Clinics::Info::ClinicVacations::EventsController < ::Clinics::Info::ClinicVacations::ApplicationController

	def index
		@events = @clinic_vacation.events
	end

end
