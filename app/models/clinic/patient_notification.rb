class Clinic::PatientNotification < ApplicationRecord
	belongs_to :clinic, class_name: "Clinic"
	belongs_to :patient, class_name: "Patient"
	enum category: {"回診推播" => 1}
	validates_presence_of :category

end
