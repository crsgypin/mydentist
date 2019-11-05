module LinebotWebhook::Replies::ClinicVacationNotificationsReply

	def reply_confirm_abort
		reply_message({
      type: 'text',
      text: "您好，你的掛號已取消"
		})		
	end

	def reply_confirm_change
		reply_message({
			type: "text",
			text: "請點選以下連結以更改掛號"
		})
	end

end

