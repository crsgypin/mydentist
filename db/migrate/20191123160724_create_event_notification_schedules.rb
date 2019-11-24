class CreateEventNotificationSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :event_notification_schedules do |t|
    	t.integer :clinic_id, index: true
    	t.integer :notification_template_id, index: true
    	t.integer :schedule_type, limit: 1, default: 1
    	t.integer :status, limit: 1, default: 0
      t.timestamps
    end
  end
end
