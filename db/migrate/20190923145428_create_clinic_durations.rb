class CreateClinicDurations < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_durations do |t|
    	t.integer :clinic_id, index: true
    	t.integer :wday, limit: 1
    	t.integer :start_hour, limite: 1
    	t.integer :start_minute, limite: 1
    	t.integer :end_hour, limite: 1
    	t.integer :end_minute, limite: 1
      t.timestamps
    end
  end
end
