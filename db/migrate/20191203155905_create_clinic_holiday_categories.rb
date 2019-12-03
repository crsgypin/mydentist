class CreateClinicHolidayCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_holiday_categories do |t|
    	t.integer :clinic_id, index: true
    	t.integer :category, limit: 1
      t.timestamps
    end
  end
end
