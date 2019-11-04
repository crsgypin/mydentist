class CreateLineSendingMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :line_sending_messages do |t|
    	t.integer :sending_id, index: true
    	t.integer :message_type, limit: 1
    	t.integer :template_type, limit: 1
    	t.text :content
      t.timestamps
    end
  end
end
