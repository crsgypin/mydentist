class CreateEventLineMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :event_line_messages do |t|
    	t.integer :event_id, index: true
    	t.integer :category, index: true
    	t.integer :line_template_id, index: true
    	t.integer :line_message_id
      t.timestamps
    end
  end
end
