class Doctor::Service < ApplicationRecord
	belongs_to :doctor
	belongs_to :service, class_name: "::Service"
	validates_uniqueness_of :doctor_id, scope: :service_id

end
