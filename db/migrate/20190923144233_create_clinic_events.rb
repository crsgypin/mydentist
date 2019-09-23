class CreateClinicEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_events do |t|
    	t.integer :clinic_id, index: true
    	t.integer :doctor_id, index: true
    	t.integer :patient_id, index: true
    	t.integer :medical_service_id, index: true
      t.integer :status, limit: 1
    	t.date :date
    	t.integer :wday, limit: 1
    	t.integer :start_hour, limit: 1
    	t.integer :start_minute, limit: 1
    	t.integer :end_hour, limit: 1
    	t.integer :end_minute, limit: 1
      t.string :doctor_name
      t.string :service_name
      t.timestamps
    end
  end
end
