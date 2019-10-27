class ClinicLine::KnowledgeCategory < ApplicationRecord
	belongs_to :clinic, class_name: "::Clinic"
	has_many :knowledges, class_name: "ClinicLine::Knowledge"

end
