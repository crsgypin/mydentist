class CreateLineKeywords < ActiveRecord::Migration[5.1]
  def change
    create_table :line_keywords do |t|
    	t.string :keywordable_type
    	t.integer :keywordable_id
    	t.integer :message_template_id, index: true
    	t.string :name
      t.timestamps
    end
    add_index :line_keywords, [:keywordable_type, :keywordable_id]
  end
end
