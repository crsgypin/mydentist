class Clinic < ApplicationRecord
	has_many :members, dependent: :restrict_with_exception
	has_many :doctors, dependent: :restrict_with_exception
	has_many :services, dependent: :restrict_with_exception
	has_many :patients, dependent: :restrict_with_exception
	has_many :events, dependent: :restrict_with_exception
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
	has_many :clinic_holidays, class_name: "Clinic::Holiday"
	has_many :clinic_holiday_categories, class_name: "Clinic::HolidayCategory"
	has_many :event_notification_templates, class_name: "Event::NotificationTemplate"
	has_many :event_notification_schedules, class_name: "Event::NotificationSchedule"
	accepts_nested_attributes_for :services
	before_validation :check_and_set_member, on: :create
	validates_presence_of :friendly_id, :name, :phone, :address
	mount_uploader :photo, PhotoUploader
	mount_uploader :map_photo, PhotoUploader
	include Common::DateTimeDurationHelper
	include Common::StaticImageHelper
	include Common::ImageHelper
	include ClinicLineAccountConcern
	attr_accessor :member_email, :member_password

	def self.default_duration
		15
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
		return true if self.clinic_holidays.find_by(date: date).present?
		return true if self.clinic_vacations.find_by("start_date <= ? and end_date >= ?", date, date).present?
		false
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
		wday_note = wday_durations_note(self.clinic_durations)
		holidays_note = "#{self.clinic_holiday_categories.map{|a| a.category}.join("、")} 休假"
		self.update!(:clinic_durations_note => "#{wday_note}\n#{holidays_note}")
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
	
	def check_and_set_member
		if !self.member_email.present?
			self.errors.add("member_email",  "未填寫email")
		end
		if !self.member_password.present?
			self.errors.add("member_password",  "未填寫密碼")
		end
		throw :abort if self.errors.present?
		new_member = self.members.new
		new_member.email = self.member_email
		new_member.password = self.member_password
		new_member.level = "管理者"
		true
	end

end
