class Linebot::Clinics::WebhookController < Linebot::Clinics::ApplicationController
	include Linebot::Clinics::Webhook::Handler

	def create
		handle_messages(params["events"])
	end

	def reply_message(data)
    linebot ||= Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.config_for('api_key')["line"]["channel_secret"]
      config.channel_token = Rails.application.config_for('api_key')["line"]["channel_access_token"]
    end
    linebot.reply_message(@reply_token, convert_reply_message(data))
    render json: {}
	end

end

