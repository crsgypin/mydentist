class CreateSysHolidays < ActiveRecord::Migration[5.1]
  def change
    create_table :sys_holidays do |t|
			t.integer :category, limit: 1
			t.string :name
			t.date :date
    	t.integer :start_hour, limit: 1
    	t.integer :end_hour, limit: 1
      t.timestamps
    end
  end
end
