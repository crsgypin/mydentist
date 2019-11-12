module EventNotificationConcern
	extend ActiveSupport::Concern
  included do
  	attr_accessor :text_message
		belongs_to :line_account, class_name: "Line::Account"
		belongs_to :line_sending, class_name: "Line::Sending", optional: true
    enum category: {"回診推播" => 1, "修改掛號" => 2}
		after_create :send_message
  end
  include LinebotWebhook::Helper::RepliedMessageHelper
  include Common::LineShareHelper

  def send_message
  	raise "no text_message" if !self.text_message.present?
    if self.category == "回診推播"
      sending = self.line_account.sendings.create!({
        source: "source",
        server_type: "push",
        message: reply_message({
          type: "confirm",
          alt_text: "回診推播訊息",
          text: "回診推播訊息",
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
              uri: liff_line_event_url(@clinic, @line_account, {event_id: self.event.id})
            }
          ]
        })        
      })
    elsif self.category == "修改掛號"
      sending = self.line_account.sendings.create!({
        source: "source",
        server_type: "push",
        message: reply_message({
          type: "confirm",
          alt_text: "修改掛號通知",
          text: "修改掛號通知",
          action: [
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
              uri: liff_line_event_url(@clinic, @line_account, {event_id: self.event.id})
            }
          ]
        })
      })
    end
    self.update!(line_sending: sending)
  end

end	

