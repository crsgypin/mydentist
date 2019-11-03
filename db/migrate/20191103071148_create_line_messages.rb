class CreateLineMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :line_messages do |t|
    	t.integer :line_account_id, index: true
    	t.integer :source, limit: 1
    	t.integer :source_type, limit: 1
    	t.integer :message_type, limit: 1
    	t.integer :status, limit: 1
    	t.text :content
      t.timestamps
    end
  end
end
