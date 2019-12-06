class Service < ApplicationRecord
	belongs_to :clinic
	has_many :events
	has_many :doctor_services, class_name: "Doctor::Service"
	has_many :doctors, through: :doctor_services
	validates_uniqueness_of :name, scope: :clinic
	enum category: {"一般" => 0, "洗牙" => 1}
	extend ServiceDurationsConcern
	enum duration: self.init_durations

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
