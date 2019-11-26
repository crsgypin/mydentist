class AddMapPhoto < ActiveRecord::Migration[5.1]
  def up
  	add_column :clinics, :lat, :string, after: :photo
  	add_column :clinics, :lng, :string, after: :lat
  	add_column :clinics, :map_photo, :string, after: :lng
  end

  def down
  	remove_column :clinics, :lat
  	remove_column :clinics, :lng
  	remove_column :clinics, :map_photo
  end
end
