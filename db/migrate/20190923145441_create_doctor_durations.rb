class CreateDoctorDurations < ActiveRecord::Migration[5.1]
  def change
    create_table :doctor_durations do |t|
      t.integer :doctor_id, index: true
      t.integer :clinic_duration_id, index: true
    	t.integer :wday, limit: 1
    	t.integer :hour, limit: 1
    	t.integer :minute, limit: 1
    	t.integer :duration, limit: 1
      t.timestamps
    end
  end
end
