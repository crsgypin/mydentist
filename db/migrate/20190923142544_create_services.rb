class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
    	t.integer :clinic_id, index: true
    	t.string :name, limit: 100
    	t.integer :duration, default: 15
      t.timestamps
    end
  end
end
