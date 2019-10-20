class AddDurationNote < ActiveRecord::Migration[5.1]
  def up
  	add_column :clinics, :clinic_durations_note, :string, limit: 500, after: :photo
  	add_column :doctors, :doctor_durations_note, :string, limit: 500, after: :web_link
  	add_column :doctors, :phone, :string, limit: 50, after: :gender
  	add_column :doctors, :note, :string, limit: 500, after: :phone
  end

  def down
  	remove_column :clinics, :clinic_durations_note
  	remove_column :doctors, :doctor_durations_note
  	remove_column :doctors, :phone
  	remove_column :doctors, :note
  end
end
