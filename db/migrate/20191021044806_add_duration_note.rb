class AddDurationNote < ActiveRecord::Migration[5.1]
  def up
  	add_column :clinics, :clinic_durations_note, :string, limit: 500, after: :photo
  	add_column :doctors, :doctor_durations_note, :string, limit: 500, after: :web_link
  	add_column :doctors, :phone, :string, limit: 50, after: :gender
  	add_column :doctors, :note, :string, limit: 500, after: :phone
    add_column :clinic_durations, :wday_hour_minute, :string, limit: 50, after: :clinic_id
    add_column :doctor_durations, :wday_hour_minute, :string, limit: 50, after: :doctor_id
    add_column :event_durations, :wday_hour_minute, :string, limit: 50, after: :event_id
    add_index :clinic_durations, :wday_hour_minute
    add_index :doctor_durations, :wday_hour_minute
    add_index :event_durations, :wday_hour_minute
    remove_column :doctor_durations, :clinic_duration_id
    rename_column :events, :hour, :start_hour
    rename_column :events, :minute, :start_minute
    rename_column :events, :duration, :total_duration
  end

  def down
  	remove_column :clinics, :clinic_durations_note
  	remove_column :doctors, :doctor_durations_note
  	remove_column :doctors, :phone
  	remove_column :doctors, :note
    remove_column :clinic_durations, :wday_hour_minute
    remove_column :doctor_durations, :wday_hour_minute
    remove_column :event_durations, :wday_hour_minute
    add_column :doctor_durations, :clinic_duration_id, :integer
    add_index :doctor_durations, :clinic_duration_id
    rename_column :events, :start_hour, :hour
    rename_column :events, :start_minute, :minute
    rename_column :events, :total_duration, :duration
  end
end
