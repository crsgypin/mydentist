class Doctor::VacationNotification < ApplicationRecord
	belongs_to :vacation
	belongs_to :event

end
