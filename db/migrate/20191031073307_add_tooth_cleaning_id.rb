class AddToothCleaningId < ActiveRecord::Migration[5.1]
  def up
  	add_column :clinics, :tooth_cleaning_service_id, :integer, after: :friendly_id
  	add_column :patients, :default_doctor_id, :integer, after: :clinic_id
  	add_column :patients, :current_event_id, :integer, after: :default_doctor_id
  	add_column :patients, :tooth_cleaning_service_id, :integer, after: :current_event_id
  	add_index :clinics, :tooth_cleaning_service_id
  	add_index :patients, :default_doctor_id
  	add_index :patients, :clinic_id
  	add_index :patients, :current_event_id
  	add_index :patients, :tooth_cleaning_service_id
  end

  def down
  	remove_column :clinics, :tooth_cleaning_service_id
  	remove_column :patients, :default_doctor_id
  	remove_column :patients, :current_event_id
  	remove_column :patients, :tooth_cleaning_service_id
  	remove_index :patients, :clinic_id
  end
end
