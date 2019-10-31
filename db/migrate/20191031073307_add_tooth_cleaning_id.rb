class AddToothCleaningId < ActiveRecord::Migration[5.1]
  def up
  	add_index :patients, :clinic_id
  	add_column :services, :category, :integer, after: :clinic_id, default: 0
  	add_column :patients, :default_doctor_id, :integer, after: :clinic_id
  	add_column :patients, :current_event_id, :integer, after: :default_doctor_id
  	add_column :patients, :last_tooth_cleaning_event_id, :integer, after: :current_event_id
  	add_index :patients, :default_doctor_id
  	add_index :patients, :current_event_id
  	add_index :patients, :last_tooth_cleaning_event_id
  end

  def down
  	remove_index :patients, :clinic_id
  	remove_column :services, :category
  	remove_column :patients, :default_doctor_id
  	remove_column :patients, :current_event_id
  	remove_column :patients, :last_tooth_cleaning_event_id
  end
end
