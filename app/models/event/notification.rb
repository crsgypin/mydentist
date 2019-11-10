class Event::Notification < ApplicationRecord
	#修改掛號通知
	belongs_to :event, class_name: "Event"
	belongs_to :new_event, class_name: "Event", foreign_key: :new_event_id, optional: true
	include EventNotificationConcern

end
