class ::Clinics::EventNotificationTemplates::NotificationsController < ::Clinics::EventNotificationTemplates::ApplicationController
	
	def create
		params[:events].each do |a,v| 
			event = @clinic.events.find_by(id: v[:id])
			args = v[:args]
			@event_notification_template.notifications.create!({
				event: event,
				line_account: event.patient.line_account,
				args_json: args
			})
		end
	end	

end

