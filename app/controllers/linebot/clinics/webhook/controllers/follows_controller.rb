module Linebot::Clinics::Webhook::Controllers::FollowsController

	def follow_create
		replies_follows_create
	end

	def follow_destroy
		@line_account.update(status: "unfollow")
		replies_follows_destroy
	end

end

