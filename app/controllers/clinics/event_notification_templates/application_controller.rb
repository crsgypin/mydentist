class ::Clinics::EventNotificationTemplates::ApplicationController < ::Clinics::ApplicationController
	before_action :set_event_notification_template

	def set_event_notification_template
		@event_notification_template = @clinic.event_notification_templates.find(params[:event_notification_template_id])
	end

end

