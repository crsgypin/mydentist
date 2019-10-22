class Doctor::Duration < ApplicationRecord
	belongs_to :doctor
	validates_presence_of :duration
	include ClinicDoctorDuration

	private
	
	
end
