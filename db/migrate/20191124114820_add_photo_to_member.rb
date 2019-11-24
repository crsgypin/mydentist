class AddPhotoToMember < ActiveRecord::Migration[5.1]
  def up
  	add_column :members, :photo, :string, after: :email
  end

  def down
  	remove_column :members, :photo
  end
end