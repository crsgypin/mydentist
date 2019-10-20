class AddDurationNote < ActiveRecord::Migration[5.1]
  def up
  	add_column :clinics, :clinic_durations_note, :string, limit: 500, after: :photo
  	add_column :doctors, :doctor_durations_note, :string, limit: 500, after: :web_link
  end

  def down
  	remove_column :clinics, :clinic_durations_note
  	remove_column :doctors, :doctor_durations_note
  end
end
