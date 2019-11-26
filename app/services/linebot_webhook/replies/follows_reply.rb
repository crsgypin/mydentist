module LinebotWebhook::Replies::FollowsReply

	def reply_follows_create
		reply_message({
      type: 'text',
      text: @message
		})		
	end

	def reply_follows_destroy
		#do nothing
	end

end

