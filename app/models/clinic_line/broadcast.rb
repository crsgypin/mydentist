class ClinicLine::Broadcast < ApplicationRecord
	belongs_to :clinic, class_name: "::Clinic"
	has_one :line_template, class_name: "Line::Template", as: :templateable, dependent: :destroy

	def message

	end

end
