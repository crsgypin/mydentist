class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.string :friendly_id
    	t.integer :clinic_id
      t.integer :profile_status, limit: 1, default: 0
    	t.string :name, limit: 100
    	t.string :phone, limit: 100
    	t.string :person_id, limit: 100
    	t.date :birthday
    	t.integer :gender, limit: 1
    	t.string :skill
    	t.string :photo
    	t.string :address
      t.timestamps
    end
  end
end
