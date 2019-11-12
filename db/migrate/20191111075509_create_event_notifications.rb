class CreateEventNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :event_notifications do |t|
    	t.integer :event_id, index: true
    	t.integer :new_event_id, index: true
      t.integer :booking_event_id, index: true
    	t.integer :line_account_id, index: true
    	t.integer :line_sending_id, index: true
      t.integer :category, limit: 1
    	t.integer :status, limit: 1, default: 0
      t.timestamps
    end
  end
end
