class Event::Notification < ApplicationRecord
	#修改掛號通知
	self.table_name = "event_notifications"	
	belongs_to :event, class_name: "Event"
	belongs_to :new_event, class_name: "Event", foreign_key: :new_event_id, optional: true
	enum status: {"尚未回覆" => 0, "同意" => 1, "取消" => 2}
	include EventBookingEventNotificationConcern 
	include LinebotWebhook::Helper::RepliedMessageHelper
	include Common::LineShareHelper

	def line_message_template(text)
		reply_message({
			type: "confirm",
			alt_text: text,
			text: text,
			actions: [
				{
					type: "postback",
					label: "否",
					data: {
						controller: "notification_events",
						action: "update",
						id: self.id,
						status: "取消"
					}
				},
				{
					type: "uri",
					label: "是，預約",
					uri: liff_line_event_url(@clinic, @line_account, {event_id: self.event.id})
				}
			]
		})		
	end

end
