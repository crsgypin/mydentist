class ClinicLine::Knowledge < ApplicationRecord
	belongs_to :knowledge_category, class_name: "ClinicLine::KnowledgeCategory"
	has_one :line_message_template, class_name: "Line::MessageTemplate", as: :templateable


end
