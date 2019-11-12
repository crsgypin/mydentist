class ::Clinics::EventNotificationTemplates::NotificationsController < ::Clinics::EventNotificationTemplates::ApplicationController
	
	def create
		@events = @clinic.events.where(id: params[:event_ids])

		@events.each do |event|
			@event_notification_template.notifications.create!({
				event: event,
				line_account: event.patient.line_account,
				args_json: params[:args]
			})
		end

	end	

end

