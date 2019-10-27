class ClinicLine::Keyword < ApplicationRecord
	belongs_to :clinic, class_name: "::Clinic"
	has_one :line_message_template, class_name: "Line::MessageTemplate", as: :templateable

	def title
		self.line_message_template.keyword_names.join(",")
	end

	def content
		self.line_message_template.first_content
	end

end
