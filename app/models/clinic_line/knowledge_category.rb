class ClinicLine::KnowledgeCategory < ApplicationRecord
	belongs_to :clinic, class_name: "::Clinic"
	has_many :knowledges, class_name: "ClinicLine::Knowledge"

	def update_clinic_line_knowledges_count
		self.update(clinic_line_knowledges_count: self.knowledges.count)
	end

end
