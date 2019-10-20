class Doctor::Duration < ApplicationRecord
	belongs_to :doctor
	before_create :set_duration
	include ClinicDoctorDuration

	private

	def set_duration
		self.duration = 15
	end
	
	
end
