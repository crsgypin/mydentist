class CreateSysHolidays < ActiveRecord::Migration[5.1]
  def change
    create_table :sys_holidays do |t|

      t.timestamps
    end
  end
end
