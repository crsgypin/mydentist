class CreateLineQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :line_questions do |t|
    	t.string :questionable_type
    	t.integer :questionable_id
    	t.string :content
    	t.integer :answers_count, limit: 1, default: 0
      t.timestamps
    end
    add_index :line_questions, [:questionable_type, :questionable_id]
  end
end
