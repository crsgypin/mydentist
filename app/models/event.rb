class Event < ApplicationRecord
  # default_scope { where.not(status: "取消")}
	belongs_to :clinic
	belongs_to :line_account, class_name: "Line::Account", foreign_key: :line_account_id, optional: true
	belongs_to :patient, optional: true
	belongs_to :doctor
	belongs_to :service
	belongs_to :ori_event, class_name: "Event", foreign_key: :ori_event_id, optional: true
	has_one :new_event, -> { order(id: :desc)}, class_name: "Event", foreign_key: :ori_event_id
	has_many :event_durations, class_name: "Event::Duration", dependent: :destroy
	has_many :event_notifications, class_name: "Event::Notification", dependent: :destroy
	has_one :event_notification_schedule, class_name: "Event::NotificationSchedule"
	enum status: {"已預約" => 10, "報到" => 15, "爽約" => 20, "已改約" => 30, "取消" => 40, "暫停" => 45, "缺少病患資料" => 55, "推播中" => 60}
	enum source: {"網路" => 1, "現場" => 2}
  enum health_insurance_status: {"有" => 1, "無" => 2}
  scope :valid_events, -> {where(status: ["已預約", "報到", "爽約"])}
  scope :valid_events_with_broadcast, -> {where(status: ["已預約", "報到", "爽約", "推播中"])}
	validates_presence_of :status, :source, :duration
	before_validation :check_for_source, on: :create
	before_validation :check_duration
	after_save :check_hour_minute_duration
	after_save :set_special_event_to_patient
	after_create :set_default_doctor
	after_destroy :set_cancel_to_schedule
	after_create :check_notification_on_create
	after_update :check_notification_on_update
	include Common::DateTimeDurationHelper
	include Common::DateHelper

	def is_valid_in_line?
		["已預約", "報到", "爽約"].include? self.status
	end

	def expired?
		Time.now > self.date_time
	end

	def date_time
		Time.parse("#{self.date} #{self.hour}:#{self.minute}")
	end

	def hour_minute=(str)
		t = parse_hour_minute_format(str)
		self.hour = t[:hour]
		self.minute = t[:minute]
	end

	def hour_minute_duration=(str)
		t = parse_hour_minute_duration_format(str)
		self.hour = t[:hour]
		self.minute = t[:minute]
		self.duration = t[:duration]
	end

	def duration_desc
		r = next_hour_minute(self.hour, self.minute, self.duration)
		"#{hour_minute_format(self.hour, self.minute)} ~ #{hour_minute_format(r[:hour], r[:minute])}"
	end

	def desc_format(format_type = 1)
		if format_type == 1
			#ex: 08:30 ~ 08:45
			r = next_hour_minute(self.hour, self.minute, self.duration)
			"#{hour_minute_format(self.hour, self.minute)} ~ #{hour_minute_format(r[:hour], r[:minute])}"			
		elsif format_type == 2			
			#ex: 108/11/18 08:30 ~ 08:45
			r = next_hour_minute(self.hour, self.minute, self.duration)
			"#{roc_format(self.date, 3)} #{hour_minute_format(self.hour, self.minute)} ~ #{hour_minute_format(r[:hour], r[:minute])}"
		elsif format_type == 3
			#ex: 108/11/21 08:30
			"#{roc_format(self.date, 3)} #{hour_minute_format(self.hour, self.minute)}"
		end
	end

	def check_hour_minute_duration
		if self.changes[:hour].present? || self.changes[:minute].present? || self.changes[:duration].present?
			self.event_durations.destroy_all
			default_duration = Clinic.default_duration
			(self.duration / default_duration).times do |index|
				hour = self.hour
				minute = self.minute + index * default_duration
				loop do
					if minute < 60
						self.event_durations.create(hour: hour, minute: minute, duration: default_duration)
						break
					end
					hour += 1
					minute -= 60
				end
				# if minute < 60
				# 	self.event_durations.create(hour: self.hour, minute: minute, duration: default_duration)
				# else
				# 	h = self.hour + 1
				# 	m = minute - 60
				# 	self.event_durations.create(hour: h, minute: m, duration: default_duration)
				# end
			end				
		end
		true
	end

	def event_durations_count
		self.duration / Clinic.default_duration
	end

	def check_for_source
		if self.doctor.nil?
			self.errors.add("doctor_id", "請選擇醫生")
		end
		if self.service.nil?
			self.errors.add("service_id", "請選擇項目")
		end
		if self.date.nil?
			self.errors.add("date", "請選擇日期")
		end
		if self.hour.nil? || self.minute.nil? || self.duration.nil?
			self.errors.add("hour", "請選擇時間")
		end
		if self.source == "現場" && !self.health_insurance_status.present?
			self.errors.add("health_insurance_status", "請填寫健保狀態")
		end
		if self.errors.present?
			throw :abort
		end
		true
	end

	def set_special_event_to_patient
		if !self.patient.present?
			return true
		end
		if self.changes[:status].present?
			self.patient.update_current_event
			if self.service.category == "洗牙"
				self.patient.update_last_tooth_cleaning_event
			end
		end
	end

	def set_default_doctor
		if !self.patient.present?
			return true
		end
		if !self.patient.default_doctor.present? || self.doctor != self.patient.default_doctor
			self.patient.update(default_doctor: self.doctor)
			true
		end
	end

	def set_cancel_to_schedule
		if self.event_notification_schedule.present?
			self.event_notification_schedule.update(status: "取消", event: nil)
		end
	end

	def check_duration
		if self.duration.nil? || self.duration == 0
			self.errors.add("需填寫區間", "")
			throw(:abort)
		end
	end

	def check_notification_on_create
    Clinic::Notification.on_add_event(self)
	end

	def check_notification_on_update
		if self.changes[:status].present?
			Clinic::Notification.on_change_event_status(self)
		end
	end

	def self.check_event_status
		n = {pass: 0, fail: 0}
		t = Time.now
		events = self.where(status: "已預約")
		ids_1 = events.where("date < ?", t.to_date).pluck(:id)
		ids_2 = events.where("date = ? and hour < ?", t.to_date, t.hour).pluck(:id)
		ids_3 = events.where("date = ? and hour = ? and minute < ?", t.to_date, t.hour, t.min).pluck(:id)
		events = events.where(id: ids_1 + ids_2 + ids_3)
		events.each do |event|
			if event.update(status: "爽約")
				n[:pass] += 1
			else
				n[:fail] += 1
			end
		end
		"pass: #{n[:pass]}, fail: #{n[:fail]}"
	end
end
