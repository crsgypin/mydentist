class CreateClinicLineKeywords < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_line_keywords do |t|
    	t.integer :clinic_id
      t.timestamps
    end
  end
end
