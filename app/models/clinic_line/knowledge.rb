class ClinicLine::Knowledge < ApplicationRecord
	belongs_to :knowledge_category, class_name: "ClinicLine::KnowledgeCategory"
	has_one :line_template, class_name: "Line::Template", as: :templateable, dependent: :destroy
	after_create :update_clinic_line_knowledges_count
	after_destroy :update_clinic_line_knowledges_count

	def update_clinic_line_knowledges_count
		self.knowledge_category.update_clinic_line_knowledges_count
	end

end
