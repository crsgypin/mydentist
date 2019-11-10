class Notification::Event < ApplicationRecord
	#修改掛號通知
	self.table_name = "notification_events"	
	belongs_to :event, class_name: "Event"
	belongs_to :new_event, class_name: "Event", foreign_key: :new_event_id, optional: true
	include NotificationConcern 
	include LinebotWebhook::Helper::RepliedMessageHelper

	def line_message_template(text)
		reply_message({
			type: "confirm",
			alt_text: text,
			text: text,
			actions: [
				{
					type: "postback",
					label: "否，取消預約",
					data: {
						controller: "event_notifications",
						action: "destroy",
						id: self.id
					}
				},
				{
					type: "postback",
					label: "是，新增預約",
					data: {
						controller: "event_notifications",
						action: "update",
						id: self.id
					}
				}
			]
		})		
	end

end
