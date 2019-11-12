class ::Clinics::Info::ClinicVacations::EventsController < ::Clinics::Info::ClinicVacations::ApplicationController

	def index
		@key = params[:key] || "events"
		@events = @clinic_vacation.events.includes(:event_notifications, :patient).order(date: :asc, hour: :asc, minute: :asc)
	end

end
