class LinebotWebhook
	attr_accessor clinic

	def initialize(events, clinic)
		@clinic = clinic
		events.map do |event|
			reply_message = handle_event(event)
		end
	end

	def handle_event(event)
    @line_user_id = event['source']['userId']
    # @reply_token = event['replyToken']
    # @event_type = event['type']
    @message = parse_message_data(event)
    @line_account = ::Line::Account.find_or_create_by(line_user_id: line_user_id)
    @line_account.update(clinic: @clinic)

		@message = message
		if message[:type] == "unfollow"
			controller("follows_controller").destroy
			return
		end
		@line_account.update(status: "follow") if @line_account.status != "follow" #always set to follow except for unfollow

		if message[:type] == "follow"
			controller("follows_controller").create
		elsif message[:type] == "message"
			if c == "預約掛號"
				controller("events_controller").create
			elsif c == "查詢掛號"
				controller("events_controller").index
			elsif c == "醫師介紹"
				controller("doctors_controller").index
			elsif c == "衛教資訊"

			elsif c == "診所資訊"
				controller("clinics_controller").show
			elsif c == "個人設定"
				controller("line_account_controller").show
			elsif c == "Hello, world"

			return handle_verify

			end
		elsif message[:type] == "postback"
			data = message[:data]
			controller("#{data[:controller]}_controller").send(data[:action])
		else
			raise "unknown type: #{message[:type]}"
		end
	end

	def controller(controller)
		eval("LinebotWebhook::Controllers::#{controller.camelize}").new(@client, @message)
	end

end

