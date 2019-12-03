class Clinic < ApplicationRecord
	has_many :members
	has_many :doctors
	has_many :services
	has_many :patients
	has_many :events
	has_many :event_durations, through: :events
	has_many :line_accounts, class_name: "Line::Account"
	has_many :clinic_durations, class_name: "Clinic::Duration"
	has_many :clinic_vacations, class_name: "Clinic::Vacation"
	has_many :clinic_patient_notifications, class_name: "Clinic::PatientNotification"
	has_many :clinic_notification_patients, through: :clinic_patient_notifications, source: :patient
	has_many :clinic_notifications, class_name: "Clinic::Notification"
	has_many :clinic_line_keywords, class_name: "ClinicLine::Keyword"
	has_many :clinic_line_knowledge_categories, class_name: "ClinicLine::KnowledgeCategory"
	has_many :clinic_line_systems, class_name: "ClinicLine::System"
	has_many :clinic_line_broadcasts, class_name: "ClinicLine::Broadcast"
	has_many :event_notification_templates, class_name: "Event::NotificationTemplate"
	has_many :event_notification_schedules, class_name: "Event::NotificationSchedule"
	accepts_nested_attributes_for :services
	validates_presence_of :friendly_id
	mount_uploader :photo, PhotoUploader
	mount_uploader :map_photo, PhotoUploader
	include Common::DateTimeDurationHelper
	include Common::StaticImageHelper
	include Common::ImageHelper
	include Common::LineShareHelper

	def self.default_duration
		15
	end

	def add_line_friend_path
		Rails.application.config_for(:api_key)['line']['add_friend_url']
	end

	def line_binding_url
		liff_patient_binding_url(self)
	end

	def to_param
		self.friendly_id
	end

	def photo_url
		if self.photo.present?
			self.photo.url
		else
			common_static_image_url(:dentist3)
		end
	end

	def has_vacation?(date)
		date_vacation = self.clinic_vacations.find_by("start_date <= ? and end_date >= ?", date, date)
		date_vacation.present?
	end

	def clinic_duration_wdays
		self.clinic_durations.group(:wday).count.keys
	end

	def max_min_hours
		(8..22)
	end

	def wday_hours(wday, segment = nil)
		clinic_durations = self.clinic_durations.where(wday: wday).uniq
		hours = clinic_durations.map{|d| d.hour}.uniq
		if segment.present?
			sh = segment_hours(segment)
			hours = hours.select do |hour|
				sh.include?(hour)
			end
		end
		hours
	end

	def wday_segment_hours(wday, segment)
		#will be depreciated
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

	def google_map_url
		if self.address.present?
			"https://www.google.com/maps?q=#{self.address}"
		else
			nil
		end
	end

	def check_map
		#no used
		if self.changes[:address].present?
			self.class.include Common::GeocoderHelper
			self.class.include GoogleStaticMap

			loc = get_lat_lang_by_address(self.address)
			self.lat = loc[:lat]
			self.lng = loc[:lng]
			path = GoogleStaticMap.get_map_photo(loc[:lat], loc[:lng])
			self.map_photo = File.open(path)
		end		
		true
	end
	
end
