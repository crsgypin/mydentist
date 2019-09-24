class Linebot::Clinics::WebhookController < Linebot::Clinics::ApplicationController
	include LinebotWebhookConcern
	include LinebotWebhookClinics
	include LinebotWebhookDoctors
	include LinebotWebhookEvents
	include LinebotWebhookPatients

	def create
		params['events'].each do |e|
      line_user_id = event['source']['userId']
      @reply_token = event['replyToken']
      event_type = event['type']
      line_account = Line::Account.find_or_create_by(line_user_id: line_user_id)
      handle_message(line_account, convert_message_data(event))
		end
	end

	def reply_message(data)
		if params[:test] == '1'
			return render json: data.to_json
		end
    linebot ||= Line::Bot::Client.new do |config|
      config.channel_secret = clinic.channel_secret
      config.channel_token = clinic.channel_token
    end
    linebot.reply_message(@reply_token, data)
    render json: {}
	end

	private

	def convert_message_data(event)
		if event["type"] == "message"
			r = {
				type: "message",
				content: event['message']['text']
			}
		elsif event["type"] == "postback"
			r = {
				type: "postback",
				content: ['postback']['data']
			}
		elsif event["type"] == "follow"
			r = {
				type: "follow",
				content: nil
			}
		end
	end

end

