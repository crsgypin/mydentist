module LinebotWebhook::Handler::Follow

	def handle_follow
		reply_message({
      type: 'text',
      text: "歡迎加入無想牙醫診所小助手"
		})
	end

	def handle_unfollow
		@line_account.update(status: "unfollow")
	end

end

