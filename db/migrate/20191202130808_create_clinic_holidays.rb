class CreateClinicHolidays < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_holidays do |t|
    	t.integer :clinic_id, index: true
    	t.string :name
    	t.date :date
    	t.integer :start_hour, limit: 1
    	t.integer :end_hour, limit: 1
      t.timestamps
    end
  end
end
