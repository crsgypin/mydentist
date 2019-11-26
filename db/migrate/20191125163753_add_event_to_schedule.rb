class AddEventToSchedule < ActiveRecord::Migration[5.1]
  def up
  	add_column :event_notification_schedules, :event_id, :integer, after: :clinic_id
  	add_index :event_notification_schedules, :event_id
  end

  def down
  	remove_column :event_notification_schedules, :event_id
  end
end
