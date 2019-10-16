class Linebot::Clinics::WebhookController < Linebot::Clinics::ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

	def create
		linebot_webhook =  LinebotWebhook.new(params["events"], @clinic)
		reply_messages = linebot_webhook.parse
		@line_account = linebot_webhook.line_account
			
		reply_messages.each do |reply_message|
	    linebot ||= Line::Bot::Client.new do |config|
	      config.channel_secret = Rails.application.config_for('api_key')["line"]["channel_secret"]
	      config.channel_token = Rails.application.config_for('api_key')["line"]["channel_access_token"]
	    end
	    @reply_token = params["events"][0]["replyToken"]
	    @line_account.update(reply_token: @reply_token)

	    response = linebot.reply_message(@reply_token, [reply_message])
	    Rails.logger.info "line response, code: #{response.code}, body: #{response.body}"
	  end
    render json: {}
	end

end

