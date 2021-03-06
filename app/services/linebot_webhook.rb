class LinebotWebhook
	include LinebotWebhook::Helper::ClientMessageHelper
	attr_accessor :line_account

	def initialize(events, clinic)
		@clinic = clinic
		@events = events
	end

	def parse
		@events.map do |event|
			reply_message = handle_event(event)
		end
	end

	def handle_event(event)
    @line_user_id = event['source']['userId']
    # @reply_token = event['replyToken']
    # @event_type = event['type']
    @message = parse_client_message(event)
    @line_account = ::Line::Account.find_or_create_by(line_user_id: @line_user_id)
    @line_account.update(clinic: @clinic)

		if @message[:type] == "unfollow"
			to("follows#destroy")
			return
		end
		@line_account.update(status: "follow") if @line_account.status != "follow" #always set to follow except for unfollow

		if @message[:type] == "follow"
			to("follows#create")
		elsif @message[:type] == "message"
			if @message[:text] == "00"
				return to("errors#debug")
			end

			if basic_messages.include?(@message[:text])
				@line_account.update(dialog_status: nil)
			end

			if @line_account.dialog_status == "預約掛號"
				return to("booking_events#update")
			elsif @line_account.dialog_status == "填寫個人資料"
				return to("patient#update")
			end

			if @message[:text] == basic_messages[0]
				to("booking_events#create")

			elsif @message[:text] == "查詢掛號" || @message[:text] == basic_messages[1]
				to("events#index")

			elsif @message[:text] == basic_messages[2]
				to("doctors#index")

			elsif @message[:text] == basic_messages[3]
				to("clinic_line_knowledge_categories#index")

			elsif @message[:text] == basic_messages[4]
				to("clinic#show")

			elsif @message[:text] == basic_messages[5]
				to("patient#show")

			elsif @message[:text] == "Hello, world"
				# to("patient#show")
				return handle_verify

			elsif Line::Keyword.find_by(name: @message[:text]).present?
				to("line_keywords#show")

			else
				to("errors#no_match")
			end
		elsif @message[:type] == "postback"
			data = @message[:data]
			controller = data[:controller]
			action = data[:action]
			to("#{controller}##{action}")
		else
			raise "unknown type: #{message[:type]}"
		end
	end

	def to(str)
		controller = str.split("#")[0]
		action = str.split("#")[1]
		Rails.logger.info "line webhook processed by #{controller} controller, action: #{action}"
		eval("LinebotWebhook::Controllers::#{controller.camelize}Controller").new(@clinic, @line_account, @message).send(action)
	end

end

