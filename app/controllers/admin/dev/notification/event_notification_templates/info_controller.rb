class Admin::Dev::Notification::EventNotificationTemplates::InfoController < Admin::Dev::Notification::EventNotificationTemplates::ApplicationController
	before_action -> {@embedded = 1}
  before_action -> {
    access_config({
      variable_name: "event_notification_template",
      find_resource: proc { @event_notification_template},
      resource_params: proc { params.require(:event_notification_template).permit(@event_notification_template.class.accessable_atts)}
    })
  }


end
