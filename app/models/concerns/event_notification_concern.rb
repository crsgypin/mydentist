module EventNotificationConcern
  #currently no use
	extend ActiveSupport::Concern
  included do
		after_create :send_message
  end
  include LinebotWebhook::Helper::RepliedMessageHelper
  include Common::LineShareHelper

  def send_message
    if self.category == "回診推播"
      sending = self.line_account.sendings.create!({
        source: "server",
        server_type: "push",
        messages: reply_message({
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
        source: "server",
        server_type: "push",
        messages: reply_message({
          type: "confirm",
          alt_text: "修改掛號通知",
          text: "修改掛號通知",
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
              uri: liff_line_event_url(self.event.clinic, self.line_account, {event_id: self.event_id})
            }
          ]
        })
      })
    end
    self.update!(line_sending: sending)
  end

end	

