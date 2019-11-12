module LinebotWebhook::Replies::EventNotificationsReply

	def reply_no_event_notification
		reply_message({
			type: "text",
			text: "很抱歉，找不到此資訊"
		})
	end

	def reply_has_canceled
		reply_message({
			type: "text",
			text: "很抱歉，你已經取消此訊息"
		})
	end

	def reply_has_agreed
		reply_message({
			type: "text",
			text: "很抱歉，你已經回覆此訊息"
		})
	end

	def reply_event_canceled
		reply_message({
			type: "text",
			text: "您已經取消此掛號"
		})
	end

end
