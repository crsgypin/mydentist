class ::Clinics::EventNotificationTemplates::NotificationsController < ::Clinics::EventNotificationTemplates::ApplicationController
	
	def create
    ActiveRecord::Base.transaction do			
		category = @event_notification_template.category
		if ["回診修改掛號", "診所休假修改掛號", "醫生休假修改掛號"].include?(category)
			params[:events].each do |a,v| 
				event = @clinic.events.find_by(id: v[:id])
				args = v[:args]
				@event_notification_template.notifications.create!({
					event: event,
					line_account: event.patient.line_account,
					args_json: args
				})
			end
		elsif ["回診推播"].include?(category)
			params[:patients].each do |a, v|
				patient = @clinic.patients.find_by(id: v[:id])
				args = v[:args]
				booking_event = patient.booking_events.create!(clinic: @clinic)
				@event_notification_template.notifications.create!({
					booking_event: booking_event,
					line_account: patient.line_account,
					args_json: args
				})
			end
		end
		end
	end	

end

