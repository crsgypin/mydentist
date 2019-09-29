module Linebot::Clinics::Webhook::Handler::Other

	def handle_verify
		reply_message({
      type: 'text',
      text: "verify"
		})
	end

	def handle_unknown_message
		reply_message({
			type: "text",
			text: "抱歉，無法判斷您的訊息"
		})
	end	

end
