module Linebot::Clinics::Webhook::Replies::Errors

	def reply_error_postback_no_action
		reply_message({
			type: "text",
			text: "錯誤! 不正確的按鈕行為"
		})
	end

end

