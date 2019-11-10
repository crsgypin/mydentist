class Notification::BookingEvent < ApplicationRecord
	#回診推播通知
	self.table_name = "notification_booking_events"	
	belongs_to :booking_event, class_name: "Event"
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
					label: "否，修改預約",
					data: {
						controller: "event_notifications",
						action: "destroy",
						id: self.id
					}
				},
				{
					type: "uri",
					label: "預約",
					uri: liff_line_event_url(@clinic, @line_account, {doctor_id: doctor.id})
				}
			]
		})		
	end

end
