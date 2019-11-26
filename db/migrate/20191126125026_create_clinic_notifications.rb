class CreateClinicNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_notifications do |t|
    	t.integer :clinic_id, index: true
    	t.integer :category
    	t.integer :patient_id
    	t.string :args
      t.timestamps
    end
  end
end
