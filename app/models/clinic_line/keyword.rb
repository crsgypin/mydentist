class ClinicLine::Keyword < ApplicationRecord
	belongs_to :clinic, class_name: "::Clinic"
	has_many :line_keywords, class_name: "Line::Keyword", as: :keywordable
	has_one :line_message_template, class_name: "Line::MessageTemplate", as: :templateable

end
