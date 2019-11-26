class Doctor::VacationNotification < ApplicationRecord
	#replaced by event_notification
	belongs_to :vacation
	belongs_to :event

end
