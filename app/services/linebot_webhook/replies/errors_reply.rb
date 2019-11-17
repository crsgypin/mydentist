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

	def reply_unbind_patient
		reply_message({
			type: "text",
			text: "已解除病患資料綁定"
		})
	end

	def reply_binding_patient
		reply_message({
			type: "text",
			text: @clinic.line_binding_url
		})
	end

end

