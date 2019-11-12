class Admin::Dev::Notification::EventNotificationTemplates::NotificationsController < Admin::Dev::Notification::EventNotificationTemplates::ApplicationController
  before_action -> {@embedded = 1}
  before_action -> {
    access_config({
      variable_name: "notification",
      new_resource: proc { @event_notification_template.notifications.new},
      find_resource: proc { @event_notification_template.notifications.find(params[:id])},
      resource_params: proc { params.require(:notification).permit(@notification.class.accessable_atts)}
    })
  }

  def index
    @notifications = @event_notification_template.notifications
    @notifications = @notifications.page(params[:page]).per(20)
  end

end
