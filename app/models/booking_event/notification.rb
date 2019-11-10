class BookingEvent::Notification < ApplicationRecord
	#回診推播通知
	belongs_to :booking_event, class_name: "Event"
	belongs_to :new_event, class_name: "Event", foreign_key: :new_event_id, optional: true
	include EventNotificationConcern

end
