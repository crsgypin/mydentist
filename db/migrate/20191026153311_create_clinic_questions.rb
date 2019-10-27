class CreateClinicQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_questions do |t|
    	t.integer :clinic_id, index: true
    	t.string :question
    	t.text :answer
      t.timestamps
    end
  end
end
