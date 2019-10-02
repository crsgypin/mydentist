class LinebotWebhook::Controllers::ErrorsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::ErrorsReply

	def postback_no_action
		reply_postback_no_action
	end	

	def clear_status
		@line_account.update(dialog_status: nil, dialog_status_step: nil)
		reply_clear_status
	end

end


