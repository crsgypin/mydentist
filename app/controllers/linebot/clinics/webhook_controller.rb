class Linebot::Clinics::WebhookController < Linebot::Clinics::ApplicationController
	include Linebot::Clinics::Webhook::WebhookRoutes

	def create
		reply_messages = LinebotWebhook.new(params["events"])

		reply_messages.each do |reply_message|
	    linebot ||= Line::Bot::Client.new do |config|
	      config.channel_secret = Rails.application.config_for('api_key')["line"]["channel_secret"]
	      config.channel_token = Rails.application.config_for('api_key')["line"]["channel_access_token"]
	    end
	    linebot.reply_message(@reply_token, reply_message)
	  end
    render json: {}
	end

end

