class Clinic < ApplicationRecord
	has_many :members
	has_many :doctors
	has_many :services
	has_many :patients
	has_many :events
	has_many :line_accounts, class_name: "Line::Account"
	has_many :clinic_durations, class_name: "Clinic::Duration"
	has_many :clinic_vacations, class_name: "Clinic::Duration"
	has_many :clinic_patient_notifications, class_name: "Clinic::PatientNotification"
	has_many :clinic_notification_patients, through: :clinic_patient_notifications, source: :patients
	validates_presence_of :friendly_id
	mount_uploader :photo, PhotoUploader
	include Common::DateTimeDurationHelper

	def to_param
		self.friendly_id
	end

	def update_clinic_durations_note!
		self.update!(:clinic_durations_note => wday_durations_note(self.clinic_durations))
	end

	def clinic_durations_note_html
		self.clinic_durations_note.gsub("\n", "<br>")
	end

	
end
