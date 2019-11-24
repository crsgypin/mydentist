class AddNotificationScheduleId < ActiveRecord::Migration[5.1]

  def up
  	add_column :event_notifications, :notification_schedule_id, :integer, after: :notification_template_id
  	add_index :event_notifications, :notification_schedule_id
  end

  def down
  	remove_column :event_notifications, :notification_schedule_id
  end
end
