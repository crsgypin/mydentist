class Service < ApplicationRecord
	belongs_to :clinic
	has_many :events
	has_many :doctor_services, class_name: "Doctor::Service"
	validates_presence_of :duration

end
