module EventNotificationConcern
	extend ActiveSupport::Concern
  included do
  	attr_accessor :text_message
		belongs_to :line_account, class_name: "Line::Account"
		belongs_to :line_sending, class_name: "Line::Sending", optional: true
    enum category: {"回診推播" => 1, "修改掛號" => 2}
		after_create :send_message
  end

  def send_message
  	raise "no text_message" if !self.text_message.present?
    if self.category == "回診推播"

    elsif self.category == "修改掛號"

    end
		sending = self.line_account.sendings.create!({
    	source: "server",
    	server_type: "push",
			message: self.line_message_template(self.text_message)
    })
    self.update!(line_sending: sending)
  end

end	

