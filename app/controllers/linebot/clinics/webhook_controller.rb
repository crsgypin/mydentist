class Linebot::Clinics::WebhookController < Linebot::Clinics::ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

	def create

		linebot_webhook =  LinebotWebhook.new(params["events"], @clinic)
		reply_messages = linebot_webhook.parse
		@line_account = linebot_webhook.line_account

		save_client_messages(@line_account, params["events"])

		reply_messages.each do |reply_message|
	    @reply_token = params["events"][0]["replyToken"]
	    @line_account.update(reply_token: @reply_token)

	    @line_account.sendings.create({
	    	source: "server",
	    	server_type: "reply",
	    	reply_token: @reply_token,
	    	messages: reply_message
	    })

	    response = linebot.reply_message(@reply_token, reply_message)
	  end
    render json: {}
	end

	private

	def save_client_messages(line_account, events)
		events.each do |event|
			line_account.sendings.create({
				source: "client",
				messages: params["events"]
			})			
		end
	end

end

