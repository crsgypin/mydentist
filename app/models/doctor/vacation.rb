class Doctor::Vacation < ApplicationRecord
	belongs_to :doctor
	has_many :vacation_notifications
	include ClinicDoctorVacation

	def event_source
		self.doctor
	end

end
