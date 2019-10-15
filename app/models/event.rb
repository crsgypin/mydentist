class Event < ApplicationRecord
	belongs_to :clinic
	belongs_to :line_account, class_name: "Line::Account", foreign_key: :line_account_id, optional: true
	belongs_to :patient, optional: true
	belongs_to :doctor, optional: true
	belongs_to :service, optional: true
	enum status: {"預約中" => 5, "已預約" => 10, "報到" => 15, "爽約" => 20, "過期" => 25, "預約中取消" => 40, "已預約取消" => 45}
	enum check_in_source: {"網路" => 1, "現場" => 2}
	before_validation :check_for_check_in_source, on: :create
	before_save :check_duration

	def hour_minute=(v)
		if v.include?(":")
			v1 = v.split(":")
			self.hour = v1[0]
			self.minute = v1[1]
		end
	end

	def hour_minute
		"#{self.hour}:#{sprintf('%02d', self.minute)}"
		# "#{self.hour}:#{self.minute}"
	end

	def check_duration
		self.duration = 15 if self.duration.nil?
		true
	end

	def check_for_check_in_source
		if self.check_in_source == "現場"
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
		end
		true
	end

end
