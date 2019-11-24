class Admin::Dev::Notification::EventNotificationSchedules::InfoController < Admin::Dev::Notification::EventNotificationSchedules::ApplicationController
  before_action -> {
    access_config({
      variable_name: "event_notification_schedule",
      find_resource: proc { @event_notification_schedule},
      resource_params: proc { params.require(:event_notification_schedule).permit(@event_notification_schedule.class.accessable_atts)}
    })
  }


end
