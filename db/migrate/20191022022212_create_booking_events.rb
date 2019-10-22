class CreateBookingEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_events do |t|
    	t.integer :clinic_id, index: true
    	t.integer :doctor_id, index: true
    	t.integer :patient_id, index: true
      t.integer :service_id, index: true
    	t.integer :line_account_id, index: true
    	t.integer :event_id, index: true
      t.date :date
      t.integer :hour, limit: 1
      t.integer :minute, limit: 1
      t.integer :duration, limit: 1
      t.timestamps
    end
  end
end
