class CreateClinicLineKnowledgeCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_line_knowledge_categories do |t|
    	t.integer :clinic_id, index: true
    	t.string :name
      t.timestamps
    end
  end
end
