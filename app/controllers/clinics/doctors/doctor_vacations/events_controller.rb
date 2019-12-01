class ::Clinics::Doctors::DoctorVacations::EventsController < ::Clinics::Doctors::DoctorVacations::ApplicationController
	include VacationEventsQueryConcern

	def index
		@events = @doctor_vacation.events.valid_events.includes(:event_notifications, :patient => :line_account)

		query_vacation_events

		@events = @events.order(date: :asc, hour: :asc, minute: :asc)

	end

end
