module Linebot::Clinics::Webhook::Replies::Events

	def replies_follows_create
		reply_message({
      type: 'text',
      text: "歡迎加入無想牙醫診所小助手"
		})		
	end

	def replies_follows_destroy
		#do nothing
	end

end

