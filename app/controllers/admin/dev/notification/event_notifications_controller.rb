class Admin::Dev::Notification::EventNotificationsController < Admin::Dev::Notification::ApplicationController
  before_action -> {@embedded = 1}, only: [:show]
  before_action -> {
    access_config({
      variable_name: "event_notification",
      new_resource: proc { ::Event::Notification.new},
      find_resource: proc { ::Event::Notification.find(params[:id])},
      resource_params: proc { params.require(:event_notification).permit(Event::Notification.accessable_atts)}
    })
  }

  def index
    @event_notifications = ::Event::Notification.all
    @event_notifications = @event_notifications.page(params[:page]).per(20)
  end

end
