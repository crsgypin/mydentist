class Clinic < ApplicationRecord
	has_many :members
	has_many :patients
	has_many :doctors
	has_many :services
	has_many :events
	has_many :clinic_durations, class_name: "Clinic::Duration"
	has_many :clinic_vacations, class_name: "Clinic::Duration"
	
end
