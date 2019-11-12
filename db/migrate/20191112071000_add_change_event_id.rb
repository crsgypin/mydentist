class AddChangeEventId < ActiveRecord::Migration[5.1]
  def up
  	add_column :events, :ori_event_id, :integer, after: :line_account_id
  	add_index :events, :ori_event_id
  end

  def down
  	remove_column :events, :ori_event_id
  end
end
