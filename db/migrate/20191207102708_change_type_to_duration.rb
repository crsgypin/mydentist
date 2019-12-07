class ChangeTypeToDuration < ActiveRecord::Migration[5.1]
  def up
  	change_column :booking_events, :duration, :integer, limit: 4
  	change_column :clinic_durations, :duration, :integer, limit: 4
  	change_column :doctor_durations, :duration, :integer, limit: 4
  	change_column :doctor_services, :duration, :integer, limit: 4
  	change_column :event_durations, :duration, :integer, limit: 4
  	change_column :events, :duration, :integer, limit: 4
  	change_column :services, :duration, :integer, limit: 4
  end

  def down
  end
end
