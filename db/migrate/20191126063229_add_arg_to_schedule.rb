class AddArgToSchedule < ActiveRecord::Migration[5.1]
  def up
  	change_column :event_notification_schedules, :event_id, :integer, after: :status
  	add_column :event_notification_schedules, :doctor_id, :integer, after: :event_id
  	add_column :event_notification_schedules, :service_id, :integer, after: :doctor_id
  	add_column :event_notification_schedules, :date, :date, after: :service_id
  	add_column :event_notification_schedules, :hour, :integer, after: :date
  	add_column :event_notification_schedules, :minute, :integer, after: :hour
  	add_column :event_notification_schedules, :duration, :integer, after: :minute
  	add_index :event_notification_schedules, :doctor_id
  	add_index :event_notification_schedules, :date
  	add_index :event_notification_schedules, :hour
  	add_index :event_notification_schedules, :minute
  	add_index :event_notification_schedules, :duration
  end

  def down
  	remove_column :event_notification_schedules, :doctor_id
  	remove_column :event_notification_schedules, :service_id
  	remove_column :event_notification_schedules, :date
  	remove_column :event_notification_schedules, :hour
  	remove_column :event_notification_schedules, :minute
  	remove_column :event_notification_schedules, :duration
  end
end
