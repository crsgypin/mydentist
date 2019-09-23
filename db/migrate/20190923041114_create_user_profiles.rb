class CreateUserProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_profiles do |t|
    	t.integer :user_id, index: true
    	t.string :phone, limit: 100
    	t.string :name, limit: name
    	t.date :birthday
      t.timestamps
    end
  end
end
