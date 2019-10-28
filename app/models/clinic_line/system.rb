class ClinicLine::System < ApplicationRecord
	belongs_to :clinic, class_name: "::Clinic"
	has_one :line_template, class_name: "Line::Template", as: :templateable
	enum category: {"歡迎" => 1, "無法判讀" => 2}	

end
