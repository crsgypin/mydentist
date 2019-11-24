class AddNotificationScheduleId < ActiveRecord::Migration[5.1]

  def up
  	add_column :event_notifications, :notification_schedule_id, :integer, after: :notification_template_id
  	add_column :event_notifications, :patient_id, :integer, after: :event_id
  	remove_column :event_notifications, :new_event_id
  	add_index :event_notifications, :notification_schedule_id
  	add_index :event_notifications, :patient_id
  end

  def down
  	remove_column :event_notifications, :notification_schedule_id
  	remove_column :event_notifications, :patient_id, :integer
  	add_column :event_notifications, :new_event_id, :integer, after: :event_id
  end
end
