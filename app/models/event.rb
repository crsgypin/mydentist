class Event < ApplicationRecord
	belongs_to :clinic
	belongs_to :line_account, class_name: "Line::Account", foreign_key: :line_account_id, optional: true
	belongs_to :patient, optional: true
	belongs_to :doctor
	belongs_to :service
	has_many :event_durations, class_name: "Event::Duration", dependent: :destroy
	enum status: {"已預約" => 10, "報到" => 15, "爽約" => 20, "過期" => 25, "預約中取消" => 40, "已預約取消" => 45}
	enum source: {"網路" => 1, "現場" => 2}
	validates_presence_of :status, :source
	before_validation :check_for_source, on: :create
	after_save :check_hour_minute_duration
	include Common::DateTimeDurationHelper

	def hour_minute_duration=(str)
		t = parse_hour_minute_duration_format(str)
		self.start_hour = t[:hour]
		self.start_minute = t[:minute]
		self.total_duration = t[:duration]
	end

	def check_hour_minute_duration
		if self.changes[:start_hour].present? || self.changes[:start_minute].present? || self.changes[:total_duration].present?
			self.event_durations.destroy_all
			default_duration = Clinic.default_duration
			(self.total_duration / default_duration).times do |index|
				minute = self.start_minute + index * default_duration
				if minute < 60
					self.event_durations.create(hour: self.start_hour, minute: minute, duration: default_duration)
				else
					h = self.start_hour + 1
					m = minute - 60
					self.event_durations.create(hour: h, minute: m, duration: default_duration)
				end
			end				
		end
		true
	end

	def event_durations_count
		self.total_duration / Clinic.default_duration
	end

	def check_for_source
		if self.doctor.nil?						
			self.errors.add("請選擇醫生","")
			return false
		end
		if self.patient.nil?
			self.errors.add("請選擇病患","")
			return false
		end
		if self.service.nil?
			self.errors.add("請選擇項目","")
			return false
		end
		if self.date.nil?
			self.errors.add("請選擇日期", "")
			return false
		end
		true
	end

end
