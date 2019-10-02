module LinebotWebhook::Replies::FollowsReply

	def reply_follows_create
		reply_message({
      type: 'text',
      text: "歡迎加入無想牙醫診所小助手"
		})		
	end

	def reply_follows_destroy
		#do nothing
	end

end

