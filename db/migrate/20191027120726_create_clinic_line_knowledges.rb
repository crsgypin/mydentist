class CreateClinicLineKnowledges < ActiveRecord::Migration[5.1]
  def change
    create_table :clinic_line_knowledges do |t|
    	t.integer :knowledge_category_id, index: true
      t.timestamps
    end
  end
end
