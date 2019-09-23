class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
    	t.integer :clinic_id, index: true
    	t.integer :doctor_id, index: true
    	t.integer :patient_id, index: true
    	t.integer :service_id, index: true
      t.integer :status, limit: 1
    	t.date :date
      t.integer :hour, limit: 1
      t.integer :minute, limit: 1
      t.integer :duration, limit: 1
      t.timestamps
    end
  end
end
