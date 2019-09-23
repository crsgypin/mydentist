class CreateEventDurations < ActiveRecord::Migration[5.1]
  def change
    create_table :event_durations do |t|
    	t.integer :event_id, index: true
    	t.integer :wday, limit: 1
    	t.integer :hour, limit: 1
    	t.integer :minute, limit: 1
    	t.integer :duration, limit: 1
      t.timestamps
    end
  end
end
