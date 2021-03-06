class CreateClinicDurations < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_durations do |t|
    	t.integer :clinic_id, index: true
    	t.integer :wday, limit: 1
    	t.integer :hour, limit: 1
    	t.integer :minute, limit: 1
    	t.integer :duration, limit: 1
      t.timestamps
    end
  end
end
