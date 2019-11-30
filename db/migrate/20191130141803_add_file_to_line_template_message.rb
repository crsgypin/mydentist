class AddFileToLineTemplateMessage < ActiveRecord::Migration[5.1]
  def up
  	add_column :line_template_messages, :file, :string, after: :content
  	add_column :clinics, :clinic_notifications_read_at, :datetime, after: :clinic_durations_note
  end

  def down
  	remove_column :line_template_messages, :file
  	remove_column :clinics, :clinic_notifications_read_at
  end
end
