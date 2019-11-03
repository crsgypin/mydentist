class Doctor::Vacation < ApplicationRecord
	belongs_to :doctor
	include ClinicDoctorVacation

	def event_source
		self.doctor
	end

end
