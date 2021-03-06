class CreateLineTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :line_templates do |t|
    	t.string :templateable_type
    	t.integer :templateable_id
      t.timestamps
    end
    add_index :line_templates, [:templateable_type, :templateable_id], name: :index_templateable_id
  end
end
