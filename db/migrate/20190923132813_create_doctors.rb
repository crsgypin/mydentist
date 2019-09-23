class CreateDoctors < ActiveRecord::Migration[5.1]
  def change
    create_table :doctors do |t|
    	t.integer :clinic_id, index: true
      t.integer :status, limit: 1, default: 1
    	t.string :name, limit: 100
    	t.string :title
    	t.text :intro
    	t.integer :gender, limit: 1
    	t.text :experience
      t.string :pro
    	t.string :web_link
      t.timestamps
    end
  end
end
