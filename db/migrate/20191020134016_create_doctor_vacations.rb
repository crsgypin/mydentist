class CreateDoctorVacations < ActiveRecord::Migration[5.1]
  def change
    create_table :doctor_vacations do |t|
    	t.integer :doctor_id, index: true
			t.date :start_date
			t.date :end_date    	
      t.timestamps
    end
  end
end
