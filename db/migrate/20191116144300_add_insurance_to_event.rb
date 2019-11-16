class AddInsuranceToEvent < ActiveRecord::Migration[5.1]
  def up
  	add_column :events, :health_insurance_status, :integer, limit: 1, after: :source

  end

  def down
  	remove_column :events, :health_insurance_status

  end
end
