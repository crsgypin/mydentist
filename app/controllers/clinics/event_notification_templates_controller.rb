class ::Clinics::EventNotificationTemplatesController < ::Clinics::ApplicationController

	def show
		@event_notification_template = @clinic.event_notification_templates.find(params[:id])

		@events = @clinic.events.where(id: params[:event_ids])
	end

end

