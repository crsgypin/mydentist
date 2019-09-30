class LinebotWebhook::Controllers::FollowsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::Follows

	def create
		reply_follows_create
	end

	def destroy
		@line_account.update(status: "unfollow")
		reply_follows_destroy
	end

end

