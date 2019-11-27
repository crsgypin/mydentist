class Doctor::Service < ApplicationRecord
	belongs_to :doctor
	belongs_to :service, class_name: "::Service"
	validates_uniqueness_of :service_id, scope: :doctor_id, message: "重複的服務"
	# enum duration: {"15分鐘" => 15, "30分鐘" => 30, "45分鐘" => 45, "1小時" => 60}
	enum has_line_booking: {"有" => 1, "無" => 0}
	before_destroy :check_for_destroy
	extend ServiceDurationsConcern
	enum duration: self.init_durations

	def duration_number
		self.read_attribute_before_type_cast(:duration)
	end

	def events
		self.service.events
	end

	def check_for_destroy
		if self.events.present?
			self.errors.add("此項目已有掛號","")
			throw :abort
		end
		true
	end

end
