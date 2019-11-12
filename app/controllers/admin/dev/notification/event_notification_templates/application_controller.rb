class Admin::Dev::Notification::EventNotificationTemplates::ApplicationController < Admin::Dev::Notification::ApplicationController
  before_action {@embedded = 1}
  before_action :find_event_notification_template

  def find_event_notification_template
    @event_notification_template = Event::NotificationTemplate.find(params[:event_notification_template_id])
  end
end
