class Admin::Dev::Notification::EventNotificationSchedules::ApplicationController < Admin::Dev::Notification::ApplicationController
  before_action {@embedded = 1}
  before_action :find_event_notification_schedule

  def find_event_notification_schedule
    @event_notification_schedule = Event::NotificationSchedule.find(params[:event_notification_schedule_id])
  end
end
