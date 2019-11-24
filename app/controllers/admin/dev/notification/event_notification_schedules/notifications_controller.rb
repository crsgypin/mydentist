class Admin::Dev::Notification::EventNotificationSchedules::NotificationsController < Admin::Dev::Notification::EventNotificationSchedules::ApplicationController
  before_action -> {
    access_config({
      variable_name: "notification",
      new_resource: proc { @event_notification_schedule.notifications.new},
      find_resource: proc { @event_notification_schedule.notifications.find(params[:id])},
      resource_params: proc { params.require(:notification).permit(@notification.class.accessable_atts)}
    })
  }

  def index
    @notifications = @event_notification_schedule.notifications
    @notifications = @notifications.page(params[:page]).per(20)
  end

end
