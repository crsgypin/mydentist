class LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Helper::RepliedMessageHelper

	def initialize(clinic, line_account, message)
		raise "no clinic" if clinic.nil?
		@client = clinic
		@line_account = line_account
		@message = message
	end	

end

