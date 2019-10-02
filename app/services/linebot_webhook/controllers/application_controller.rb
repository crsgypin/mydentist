class LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Helper::RepliedMessageHelper
	include Common::StringHelper
	include Common::LineShareHelper

	def initialize(clinic, line_account, message)
		raise "no clinic" if clinic.nil?
		@clinic = clinic
		@line_account = line_account
		@message = message
	end	


end

