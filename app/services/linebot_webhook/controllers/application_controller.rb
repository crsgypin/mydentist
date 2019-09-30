class LinebotWebhook::Controllers::ApplicationController

	def initialize(client, message)
		@client = client
		@message = message
	end	

end

