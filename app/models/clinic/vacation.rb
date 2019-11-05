class Clinic::Vacation < ApplicationRecord
	belongs_to :clinic
	has_many :vacation_notifications
	include ClinicDoctorVacation

	def event_source
		self.clinic
	end
	
end
