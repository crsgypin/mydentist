class CreateLineSendings < ActiveRecord::Migration[5.1]
  def change
    create_table :line_sendings do |t|
    	t.integer :account_id, index: true
      t.integer :client_sending_id, index: true
    	t.integer :source, limit: 1
    	t.integer :server_type, limit: 1
    	t.integer :status, limit: 1
    	t.string :error_message
      t.timestamps
    end
  end
end
