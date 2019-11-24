class ::Clinics::Info::ClinicVacations::EventsController < ::Clinics::Info::ClinicVacations::ApplicationController
	include VacationEventsQueryConcern

	def index
		@key = params[:key] || "events"

		@events = @clinic_vacation.events.includes(:event_notifications, :patient => :line_account)

		query_vacation_events

		@events = @events.order(date: :asc, hour: :asc, minute: :asc)
	end

end
