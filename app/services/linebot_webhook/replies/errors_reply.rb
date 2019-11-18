module LinebotWebhook::Replies::ErrorsReply

	def reply_error_postback_no_action
		reply_message({
			type: "text",
			text: "錯誤! 不正確的按鈕行為"
		})
	end

	def reply_debug
		r = reply_message({
			type: "reply_button",
			alt_text: "測試項目",
			title: "測試項目",
			text: "請選擇你要操作的功能",
      # image_url: "",
			default_action: {
				type: "postback",
        label: "移除狀態",
				data: {
					controller: "errors",
					action: "reply_clear_status",
				}
			},
			actions: [
				{
					type: "postback",
	        label: "移除狀態",
					data: {
						controller: "errors",
						action: "clear_status",
					},
				},
				{
					type: "postback",
	        label: "解除病患資料綁定",
					data: {
						controller: "errors",
						action: "unbind_patient",
					},
				},
				{
					type: "uri",
					label: "預約",
					uri: @clinic.line_binding_url
				}
			]
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

	# def reply_binding_patient
	# 	reply_message({
	# 		type: "text",
	# 		text: @clinic.line_binding_url
	# 	})
	# end

end

