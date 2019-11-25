class ::Clinics::EventNotificationSchedulesController < ::Clinics::ApplicationController

	def new
		@event_notification_schedule = @clinic.event_notification_schedules.new

		@schedule = params[:event_notification_schedule]
		
		@event_notification_template = @clinic.event_notification_templates.find_by!(category: @schedule[:category])
	end

	def create
		@event_notification_schedule = @clinic.event_notification_schedules.new
		@event_notification_schedule.assign_attributes(event_notification_schedule_params)
		if !@event_notification_schedule.save
			return js_render_model_error @event_notification_schedule
		end
	end

	private

	def event_notification_schedule_params
		params.require(:event_notification_schedule).permit(:schedule_type, :notification_template_id, notifications_attributes: [:event_id, :patient_id, :args, :notification_template_id])
		# params.require(:line_template).permit(keywords_attributes: [:name], template_messages_attributes: [:content])
	end

	# for schedule params
	# event_notification_schedule: {
	# 	schedule_type: xxxx
	# 	notification_template_id: xxxx,
	# 	notifications_attributes: [
	# 		{
	# 			notification_template_id: xxxx,
	# 			event_id: xxxx,
	# 			booking_event_id: xxxx,
	# 			args: {xxx}
	# 		}
	# 	]
	# }

end

