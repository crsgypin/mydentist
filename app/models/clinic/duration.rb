class Clinic::Duration < ApplicationRecord
	belongs_to :clinic
	validates_presence_of :duration
	include ClinicDoctorDuration

end
