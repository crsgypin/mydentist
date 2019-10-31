class Service < ApplicationRecord
	belongs_to :clinic
	has_many :events
	has_many :doctor_services, class_name: "Doctor::Service"
	enum category: {"一般" => 0, "洗牙" => 1}
	validates_presence_of :duration

end 
