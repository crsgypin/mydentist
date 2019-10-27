class CreateLineAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :line_answers do |t|
    	t.integer :question_id, index: true
    	t.integer :category, limit: 1
    	t.text :content
      t.timestamps
    end
  end
end
