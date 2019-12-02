class AddCountToKnowledgeCategory < ActiveRecord::Migration[5.1]
  def up
  	add_column :clinic_line_knowledge_categories, :clinic_line_knowledges_count, :integer, default: 0, after: :name
  end

  def down
  	remove_column :clinic_line_knowledge_categories, :clinic_line_knowledges_count
  end
end
