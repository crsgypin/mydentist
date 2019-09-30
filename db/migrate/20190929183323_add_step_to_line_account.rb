class AddStepToLineAccount < ActiveRecord::Migration[5.1]
  def up
  	change_column :line_accounts, :dialog_status, :integer, limit: 1, after: :status
  	add_column :line_accounts, :dialog_status_step, :integer, limit: 1, after: :dialog_status
  end

  def down
  	remove_column :line_accounts, :dialog_status_step
  end
end
