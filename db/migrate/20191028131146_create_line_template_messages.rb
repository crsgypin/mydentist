class CreateLineTemplateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :line_template_messages do |t|
    	t.integer :template_id, index: true
    	t.integer :category
    	t.text :content
      t.timestamps
    end
  end
end
