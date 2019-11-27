class Admin::Dev::LinebotController < Admin::Dev::ApplicationController

	def new
		@clinic = Clinic.first
	end

	def create
		@clinic = Clinic.find_by(friendly_id: params[:clinic_id])
		linebot_webhook =  LinebotWebhook.new(params["events"], @clinic)
		reply_messages = linebot_webhook.parse
		@line_account = linebot_webhook.line_account
		@client_sending = @line_account.sendings.create!({
			source: "client",
			messages: params["events"]
		})			

		reply_messages.each do |reply_message|
	    @line_account.sendings.create!({
	    	client_sending: @client_sending,
	    	source: "server",
	    	server_type: "reply",
	    	reply_token: @reply_token,
	    	messages: reply_message,
	    	status: "測試" #no sending
	    })
	  end

		@data = reply_messages.map do |reply_message|
			r = {
				reply_message: reply_message,
				line_account: @line_account.attributes,
			}
		end.first
	end


end