class Event::Notification < ApplicationRecord
	#修改掛號通知
	self.table_name = "event_notifications"	
	belongs_to :event, class_name: "Event", optional: true
	belongs_to :new_event, class_name: "Event", foreign_key: :new_event_id, optional: true
	belongs_to :booking_event, class_name: "Booking::Event", optional: true
	belongs_to :line_account, class_name: "Line::Account"
	belongs_to :line_sending, class_name: "Line::Sending", optional: true
  enum category: {"回診推播" => 1, "修改掛號" => 2}
	enum status: {"尚未回覆" => 0, "同意" => 1, "取消" => 2}
	validates_presence_of :category
	include EventNotificationConcern 

end
