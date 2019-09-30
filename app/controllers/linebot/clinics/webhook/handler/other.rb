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

	def handle_invalid_status(ori_message)
		@line_account.update(dialog_status: nil, dialog_status_step: nil)
		if ori_message[:type] == "message"
			reply_message({
				type: "text",
				text: "狀態錯誤，已回覆正常程序"
			})
		elsif ori_message[:type] == "postback"
			reply_message({
				type: "text",
				text: "狀態錯誤，已回覆正常程序"
			})
		end
	end	

end
