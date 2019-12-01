class CreateSysLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :sys_logs do |t|
    	t.string :name
    	t.string :note
      t.timestamps
    end
  end
end
