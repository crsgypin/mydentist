class ::Clinics::Info::ClinicVacations::EventsController < ::Clinics::Info::ClinicVacations::ApplicationController

	def index
		@events = @clinic_vacation.events.includes(:patient).order(date: :asc, hour: :asc, minute: :asc)
	end

end
