class ::Clinics::EventNotificationTemplates::NotificationsController < ::Clinics::EventNotificationTemplates::ApplicationController
	
	def create
		@events = @clinic.events.where(id: params[:event_ids])

		@events.each do |event|
			event.event_notifications.create!({
				notification_template: @event_notification_template,
				line_account: event.patient.line_account
			})
		end

	end	

end

