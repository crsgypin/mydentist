class AddLineAccountToEvent < ActiveRecord::Migration[5.1]
  def up
  	add_column :line_accounts, :clinic_id, :integer, after: :id
  	add_column :events, :line_account_id, :integer, after: :service_id
  	add_index :events, :line_account_id
  end

  def down
  	remove_column :line_accounts, :clinic_id
  	remove_column :events, :line_account_id
	end
end
