class LineBot::WebhookController < LineBot::ApplicationController
	before_action :set_clinic
	include WebhookHandler

	def create
		params['events'].each do |e|
      line_user_id = event['source']['userId']
      reply_token = event['replyToken']
      event_type = event['type']
      line_account = Line::Account.find_or_create_by(line_user_id: line_user_id)
      handle_message(line_account, convert_message_data(event))
		end
	end

	private

	def set_clinic
		@clinic = Clinic.find_by(friendly_id: params[:clinic_id])
	end

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
				type: "follow"
				content: nil
			}
		end
	end

end

