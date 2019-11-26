class LinebotWebhook::Controllers::FollowsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::FollowsReply

	def create
		@message = ClinicLine::System.find_by(category: "歡迎").line_template.message_contents.join(",")
		reply_follows_create
	end

	def destroy
		@line_account.update(status: "unfollow")
		reply_follows_destroy
	end

end

