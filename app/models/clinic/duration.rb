class Clinic::Duration < ApplicationRecord
	belongs_to :clinic
	before_create :set_duration
	include ClinicDoctorDuration

	private

	def set_duration
		self.duration = 15
	end

end
