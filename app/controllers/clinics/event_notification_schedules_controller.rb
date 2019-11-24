class ::Clinics::EventNotificationSchedulesController < ::Clinics::ApplicationController

	def new
		@event_notification_template = @clinic.event_notification_templates.find_by!(category: params[:category])

		@event_notification_schedule = @clinic.event_notification_schedules.new

		@notifications = params[:notifications]
 	  # if ["回診修改掛號", "診所休假修改掛號", "醫生休假修改掛號"].include? params[:category]
		# 	@notifications = []
		# 	params[:notifications] && params[:notifications].each do |a,notification| 
		# 		r = {
		# 			event_id: notification[:id],
		# 			args: notification[:args]
		# 		}
		# 		@notifications << r
		# 	end
		# 	return js_render_error "你尚未選擇推播病患" if @notifications.length == 0
		# elsif ["回診推播"].include? @event_notification_schedule.category
		# 	@notifications = []
		# 	params[:notifications] && params[:notifications].each do |a, notification|
		# 		r = {
		# 			patient_id: notifications[:patient_id],
		# 			args: notification[:args]
		# 		}
		# 		@notifications << r
		# 	end
		# 	return js_render_error "你尚未選擇推播病患" if @notifications.length == 0
		# end
	end

	def create
		@event_notification_schedule = @clinic.event_notification_schedules.new
		@event_notification_schedule.notification_template = @clinic.event_notification_templates.find_by!(event_notification_template_id: params[:event_notification_template_id])
		@event_notification_schedule.assign_attributes(event_notification_schedule_params)

	end

	private

	def event_notification_schedule_params
		params.require(:event_notification_schedule).permit(notifications_attributes: [:event_id, :patient_id, :args])
		# params.require(:line_template).permit(keywords_attributes: [:name], template_messages_attributes: [:content])
	end

end

