class LinebotWebhook::Controllers::ErrorsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::ErrorsReply

	def postback_no_action
		reply_postback_no_action
	end	

	def debug
		reply_debug
	end

	def clear_status
		@line_account.update(dialog_status: nil, dialog_status_step: nil)
		reply_clear_status
	end

	def unbind_patient
		@line_account.update(patient: nil)
		reply_unbind_patient
	end

	# def binding_patient
	# 	reply_binding_patient
	# end

end


