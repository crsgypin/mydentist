class Admin::Dev::Notification::EventNotificationTemplatesController < Admin::Dev::Notification::ApplicationController
  before_action -> {@embedded = 1}, only: [:show]
  before_action -> {
    access_config({
      variable_name: "event_notification_template",
      new_resource: proc { ::Event::NotificationTemplate.new},
      find_resource: proc { ::Event::NotificationTemplate.find(params[:id])},
      resource_params: proc { params.require(:event_notification_template).permit(Event::NotificationTemplate.accessable_atts)}
    })
  }

  def index
    @event_notification_templates = ::Event::NotificationTemplate.all
    @event_notification_templates = @event_notification_templates.page(params[:page]).per(20)
  end

end
