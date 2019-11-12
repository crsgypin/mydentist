class Event::Notification < ApplicationRecord
	#修改掛號通知
	self.table_name = "event_notifications"	
	belongs_to :event, class_name: "Event", optional: true
	belongs_to :new_event, class_name: "Event", foreign_key: :new_event_id, optional: true
	belongs_to :booking_event, class_name: "Booking::Event", optional: true
	enum status: {"尚未回覆" => 0, "同意" => 1, "取消" => 2}
	include EventNotificationConcern 

end
