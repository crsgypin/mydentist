class CreateLineKeywords < ActiveRecord::Migration[5.1]
  def change
    create_table :line_keywords do |t|
    	t.integer :template_id, index: true
    	t.string :name
      t.timestamps
    end
  end
end
