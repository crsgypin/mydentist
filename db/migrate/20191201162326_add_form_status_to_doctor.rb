class AddFormStatusToDoctor < ActiveRecord::Migration[5.1]
  def up
  	add_column :doctors, :form_complete, :integer, limit: 1, default: 0, after: :doctor_durations_note
  	add_column :patients, :current_event_notification_id, :integer, after: :source
  	add_index :patients, :current_event_notification_id
  end

  def down
  	remove_column :doctors, :form_complete
  	remove_column :patients, :current_event_notification_id
  end
end
