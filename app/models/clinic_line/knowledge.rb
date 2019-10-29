class ClinicLine::Knowledge < ApplicationRecord
	belongs_to :knowledge_category, class_name: "ClinicLine::KnowledgeCategory"
	has_one :line_template, class_name: "Line::Template", as: :templateable, dependent: :destroy


end
