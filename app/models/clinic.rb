class Clinic < ApplicationRecord
	has_many :members
	has_many :doctors
	has_many :services
	has_many :patients
	has_many :events
	has_many :event_durations, through: :events
	has_many :line_accounts, class_name: "Line::Account"
	has_many :clinic_durations, class_name: "Clinic::Duration"
	has_many :clinic_vacations, class_name: "Clinic::Duration"
	has_many :clinic_patient_notifications, class_name: "Clinic::PatientNotification"
	has_many :clinic_notification_patients, through: :clinic_patient_notifications, source: :patients
	has_many :clinic_line_keywords, class_name: "ClinicLine::Keyword"
	has_many :clinic_line_knowledge_categories, class_name: "ClinicLine::KnowledgeCategory"
	has_many :clinic_line_systems, class_name: "ClinicLine::System"
	has_many :clinic_line_broadcasts, class_name: "ClinicLine::Broadcast"
  belongs_to :tooth_cleaning_service, class_name: "::Service", foreign_key: :tooth_cleaning_service_id, optional: true
	validates_presence_of :friendly_id
	mount_uploader :photo, PhotoUploader
	include Common::DateTimeDurationHelper

	def self.default_duration
		15
	end

	def to_param
		self.friendly_id
	end

	def wday_segment_hours(wday, segment)
		default_segment_hours = segment_hours(segment)
		clinic_durations = self.clinic_durations.where(wday: wday).uniq
		hours = clinic_durations.map{|d| d.hour}.uniq.select do |hour|
			default_segment_hours.include?(hour)
		end
		hours
	end

	def update_clinic_durations_note!
		self.update!(:clinic_durations_note => wday_durations_note(self.clinic_durations))
	end

	def clinic_durations_note_html
		self.clinic_durations_note.gsub("\n", "<br>")
	end

	
end
