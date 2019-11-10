class CreateBookingEventNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_event_notifications do |t|
    	t.integer :booking_event_id, index: true
    	t.integer :new_event_id, index: true
    	t.integer :patient_id, index: true
    	t.integer :line_sending_id, index: true
    	t.integer :status, limit: 1, default: 0
      t.timestamps
    end
  end
end
