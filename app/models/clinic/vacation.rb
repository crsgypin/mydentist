class Clinic::Vacation < ApplicationRecord
	belongs_to :clinic
	include ClinicDoctorVacation

	def event_source
		self.clinic
	end
	
end
