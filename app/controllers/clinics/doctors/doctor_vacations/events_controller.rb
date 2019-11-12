class ::Clinics::Doctors::DoctorVacations::EventsController < ::Clinics::Doctors::DoctorVacations::ApplicationController
	include VacationEventsQueryConcern

	def index
		@events = @doctor_vacation.events.includes(:event_notifications, :patient => :line_account)

		query_vacation_events

		@events = @events.order(date: :asc, hour: :asc, minute: :asc)

		@event_notification_template = @clinic.event_notification_templates.find_by(category: "醫生休假修改掛號")
	end

end
