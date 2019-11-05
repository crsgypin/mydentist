class CreateClinicVacationNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_vacation_notifications do |t|
    	t.integer :vacation_id, index: true
    	t.integer :event_id, index: true
    	t.integer :line_sending_id, index: true
      t.timestamps
    end
  end
end
