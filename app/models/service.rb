class Service < ApplicationRecord
	belongs_to :clinic
	has_many :events
	has_many :doctor_services, class_name: "Doctor::Service"
	enum category: {"一般" => 0, "洗牙" => 1}
	enum duration: {"依情況而定" => nil, "15分鐘" => 15, "30分鐘" => 30, "45分鐘" => 45, "1小時" => 60}
	before_destroy :check_for_destroy
	validates_presence_of :name

	def duration_number
		self.read_attribute_before_type_cast(:duration)
	end

	def check_for_destroy
		if self.events.present?
			self.errors.add("此項目已有掛號","")
			throw :abort
		elsif self.doctor_services.present?
			self.errors.add("此項目已有醫師使用 #{self.doctor_services.map{|a| a.doctor.name}.join(",")}","")
			throw :abort
		end
		true
	end

end 
