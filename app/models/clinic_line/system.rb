class ClinicLine::System < ApplicationRecord
	belongs_to :clinic, class_name: "::Clinic"
	has_one :line_template, class_name: "Line::Template", as: :templateable, dependent: :destroy
	enum category: {"歡迎" => 1, "無法判讀" => 2, "診所休假變動通知" => 3, "醫生休假變動通知" => 4}	

	def self.clinic_vacation_change_note
		self.find_by(category: "診所休假變動通知").line_template.content
	end

	def self.doctor_vacation_change_note
		self.find_by(category: "醫生休假變動通知").line_template.content
	end

end
