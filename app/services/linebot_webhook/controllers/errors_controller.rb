class LinebotWebhook::Controllers::EventsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::Errors

	def postback_no_action
		reply_postback_no_action
	end	

end


