class AddReplyTokenToAccount < ActiveRecord::Migration[5.1]
  def up
  	add_column :line_accounts, :reply_token, :string, after: :status_message
  	add_column :line_accounts, :reply_token_time, :datetime, after: :reply_token
  end

  def down
  	remove_column :line_accounts, :reply_token
  	remove_column :line_accounts, :reply_token_time
  end
end
