class CreateDoctorServices < ActiveRecord::Migration[5.1]
  def change
    create_table :doctor_services do |t|
    	t.integer :doctor_id, index: true
    	t.integer :service_id, index: true
    	t.integer :duration, default: 15
      t.timestamps
    end
  end
end
