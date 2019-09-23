class CreateClinicVacations < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_vacations do |t|
    	t.integer :clinic_id, index: true
    	t.date :date
      t.timestamps
    end
  end
end
