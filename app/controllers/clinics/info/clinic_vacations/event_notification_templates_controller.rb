class ::Clinics::Info::ClinicVacations::EventNotificationTemplatesController < ::Clinics::Info::ClinicVacations::ApplicationController

	def show
		@event_notification_template = Event::NotificationTemplate.find_by(id: params[:id])
		@events = @clinic_vacation.events.where(id: params[:event_ids])
	end

	def create
		@event_notification_template = Event::NotificationTemplate.find_by(id: params[:id])

		@events = @clinic_vacation.events.where(id: params[:event_ids])
		@events.each do |event|
			event.event_notifications.create!({
				line_account: event.patient.line_account,
				text_message: params[:text_message],
				category: "修改掛號"
			})
		end
	end

end
