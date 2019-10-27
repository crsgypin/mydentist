class CreateClinicLineSystems < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_line_systems do |t|
    	t.integer :clinic_id
    	t.integer :category, limit: 1
      t.timestamps
    end
  end
end
