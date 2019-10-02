module LinebotWebhook::Replies::ErrorsReply

	def reply_error_postback_no_action
		reply_message({
			type: "text",
			text: "錯誤! 不正確的按鈕行為"
		})
	end

	def reply_clear_status
		reply_message({
			type: "text",
			text: "狀態已移除"
		})
	end

end

