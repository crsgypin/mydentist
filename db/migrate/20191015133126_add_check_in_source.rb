class AddCheckInSource < ActiveRecord::Migration[5.1]
  def up
  	add_column :events, :source, :integer, limit: 1, default: 1, after: :status
  	add_column :patients, :source, :integer, limit: 1, default: 1, after: :profile_status
  end

  def down
  	remove_column :events, :source
  	remove_column :patients, :source
  end
end
