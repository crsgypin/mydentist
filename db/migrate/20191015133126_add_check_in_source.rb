class AddCheckInSource < ActiveRecord::Migration[5.1]
  def up
  	add_column :events, :check_in_source, :integer, limit: 1, default: 1, after: :status
  end

  def down
  	remove_column :events, :check_in_source
  end
end
