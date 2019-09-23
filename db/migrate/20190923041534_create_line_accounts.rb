class CreateLineAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :line_accounts do |t|
    	t.integer :patient_id, index: true
    	t.string :line_user_id
    	t.integer :status
    	t.string :display_name
    	t.string :picture_url
    	t.text :status_message
      t.timestamps
    end
  end
end
