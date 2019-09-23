class CreateClinics < ActiveRecord::Migration[5.1]
  def change
    create_table :clinics do |t|
    	t.string :friendly_id
	    t.string :name, limit: 100
	    t.string :name_en, limit: 100
	    t.string :phone, limit: 100
	    t.string :address, limit: 100
	    t.text :description
	    t.string :channel_secret
	    t.string :channel_token
	    t.text :recommend
	    t.text :photo
      t.timestamps
    end
  end
end
