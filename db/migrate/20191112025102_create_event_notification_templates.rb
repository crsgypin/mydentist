class CreateEventNotificationTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :event_notification_templates do |t|
    	t.integer :clinic_id, index: true
    	t.integer :category, limit: 1
    	t.text :content
      t.timestamps
    end
  end
end
