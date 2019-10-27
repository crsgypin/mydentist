class ClinicLine::Keyword < ApplicationRecord
	belongs_to :clinic, class_name: "::Clinic"
	has_one :line_message_template, class_name: "Line::MessageTemplate", as: :templateable

end
