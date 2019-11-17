class AddInsuranceToEvent < ActiveRecord::Migration[5.1]
  def up
  	add_column :events, :health_insurance_status, :integer, limit: 1, after: :source
  	add_column :doctor_services, :has_line_booking, :integer, limit: 1, after: :duration, default: 1
  end

  def down
  	remove_column :events, :health_insurance_status
  	remove_column :doctor_services, :has_line_booking
  end
end
