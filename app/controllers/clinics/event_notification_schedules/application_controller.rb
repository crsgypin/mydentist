class ::Clinics::EventNotificationSchedules::ApplicationController < ::Clinics::ApplicationController
	before_action :set_event_notification_schedule

	def set_event_notification_schedule
		event_notification_schedule = @clinic.event_notification_schedules.find(params[:event_notification_schedule_id])
	end

end

