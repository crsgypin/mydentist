class Admin::Dev::Notification::EventNotificationSchedulesController < Admin::Dev::Notification::ApplicationController
  before_action -> {@embedded = 1}, only: :show
  before_action -> {
    access_config({
      variable_name: "event_notification_schedule",
      new_resource: proc { ::Event::NotificationSchedule.new},
      find_resource: proc { ::Event::NotificationSchedule.find(params[:id])},
      resource_params: proc { params.require(:event_notification_schedule).permit(Event::NotificationSchedule.accessable_atts)}
    })
  }

  def index
    @event_notification_schedules = ::Event::NotificationSchedule.all
    @event_notification_schedules = @event_notification_schedules.page(params[:page]).per(20)
  end

end
