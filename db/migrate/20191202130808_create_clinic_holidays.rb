class CreateClinicHolidays < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_holidays do |t|
    	t.date :date
    	t.integer :name
      t.timestamps
    end
  end
end
