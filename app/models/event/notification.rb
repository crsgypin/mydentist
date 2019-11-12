class Event::Notification < ApplicationRecord
	#修改掛號通知
	self.table_name = "event_notifications"	
	belongs_to :notification_template
	belongs_to :line_account, class_name: "Line::Account"
	belongs_to :event, class_name: "Event", optional: true
	belongs_to :new_event, class_name: "Event", foreign_key: :new_event_id, optional: true
	belongs_to :booking_event, class_name: "Booking::Event", optional: true
	belongs_to :line_sending, class_name: "Line::Sending", optional: true
	enum status: {"尚未發送" => 0, "尚未回覆" => 1, "同意" => 2, "取消" => 3}
	after_create :send_message
  json_format :args
	# validates_presence_of :category
	# include EventNotificationConcern 

  include LinebotWebhook::Helper::RepliedMessageHelper
  include Common::LineShareHelper

  def send_message
    sending = self.line_account.sendings.create!({
      source: "server",
      server_type: "push",
      messages: reply_message({
        type: "confirm",
        alt_text: self.arg_content,
        text: self.arg_content,
        actions: [
          {
            type: "postback",
            label: "否",
            data: {
              controller: "event_notifications",
              action: "update",
              id: self.id,
              status: "取消"
            }
          },
          {
            type: "uri",
            label: "是，預約",
            uri: liff_line_event_url(self.notification_template.clinic, self.line_account, {event_id: self.event.id, event_notification_id: self.id})
          }
        ]
      })        
    })
    self.update!(line_sending: sending, status: "尚未回覆")
  end

  def arg_content
    @arg_content ||= self.notification_template.arg_content(self.args_json)
  end

end
