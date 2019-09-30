class LinebotWebhook

	def initialize(events)
		events.map do |event|
			reply_message = handle_message(event)
		end
	end

	def handle_message(message)
    @line_user_id = event['source']['userId']
    @reply_token = event['replyToken']
    @event_type = event['type']
    @data = parse_message_data(event)
    @line_account = ::Line::Account.find_or_create_by(line_user_id: line_user_id)
    @line_account.update(clinic: @clinic)

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
	end

end

