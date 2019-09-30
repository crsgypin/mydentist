module LinebotWebhook::WebhookRoutes
	extend ActiveSupport::Concern
  included do
		include LinebotWebhook::Handler::Model::Clinics
		include LinebotWebhook::Handler::Model::Doctors
		include LinebotWebhook::Handler::Model::Events
		include LinebotWebhook::Handler::Model::Patients
		include LinebotWebhook::Handler::Follow
		include LinebotWebhook::Handler::Other
		include LinebotWebhook::Handler::DataHelper
  end

  def handle_messages(events)
		events.each do |event|
      line_user_id = event['source']['userId']
      @reply_token = event['replyToken']
      event_type = event['type']
      data = parse_message_data(event)
      @line_account = ::Line::Account.find_or_create_by(line_user_id: line_user_id)
      @line_account.update(clinic: @clinic)
      handle_message(data)
		end
	end

	private

	def handle_message(message)
		@message = message
		if message[:type] == "unfollow"
			follow_destroy
			return
		end
		@line_account.update(status: "follow") if @line_account.status != "follow" #always set to follow except for unfollow
		if message[:type] == "follow"
			follow_create
		elsif message[:type] == "message"
			if c == "預約掛號"
				event_create
			elsif c == "查詢掛號"

			elsif c == "醫師介紹"

			elsif c == "衛教資訊"

			elsif c == "診所資訊"

			elsif c == "個人設定"

			elsif c == "Hello, world"

			return handle_verify

			end
		elsif message[:type] == "postback"
			data = message[:data]
			return reply_error_postback_no_action if data[:action]
			eval(data[:action])
		else
			raise "unknown type: #{message[:type]}"
		end


		begin
		if t == "message"
			if c == "預約掛號"
				event_create(message)
			elsif c == "查詢掛號"
				event_index
			elsif c == "醫師介紹"
				doctors_index
			elsif c == "衛教資訊"
				
			elsif c == "診所資訊"
				clinic_show
			elsif c == "個人設定"
				patient_edit
			else
				handle_unknown_message
			end
		elsif @line_account.dialog_status == "預約掛號"
			event_create(message)
		else
			handle_unknown_message
		end
		rescue Exception => e
			if e.to_s.include? "invalid_status"
				handle_invalid_status(message)
			else
				raise e
			end
		end
	end

end