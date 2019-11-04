class Linebot::Clinics::WebhookController < Linebot::Clinics::ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

	def create
		linebot_webhook =  LinebotWebhook.new(params["events"], @clinic)
		reply_messages = linebot_webhook.parse
		@line_account = linebot_webhook.line_account
			
		reply_messages.each do |reply_message|
	    @reply_token = params["events"][0]["replyToken"]
	    @line_account.update(reply_token: @reply_token)

	    @line_account.sendings.create({
	    	reply_token: @reply_token,
	    	messages: reply_message
	    })

	    response = linebot.reply_message(@reply_token, reply_message)
	  end
    render json: {}
	end

end

