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
			controller("follows_controller").destroy
			return
		end
		@line_account.update(status: "follow") if @line_account.status != "follow" #always set to follow except for unfollow

		if @message[:type] == "follow"
			controller("follows_controller").create
		elsif @message[:type] == "message"
			if @message[:text] == "00"
				return controller("errors_controller").clear_status
			end

			if @line_account.dialog_status == "預約掛號"
				return controller("events_controller").update
			elsif @line_account.dialog_status == "填寫個人資料"
				return controller("patient_controller").update
			end

			if @message[:text] == "預約掛號"
				controller("events_controller").create

			elsif @message[:text] == "查詢掛號"
				controller("events_controller").index

			elsif @message[:text] == "醫師介紹"
				controller("doctors_controller").index

			elsif @message[:text] == "衛教資訊"

			elsif @message[:text] == "診所資訊"
				controller("clinic_controller").show

			elsif @message[:text] == "個人設定"
				controller("patient_controller").show

			elsif @message[:text] == "Hello, world"
				# controller("patient_controller").show
			return handle_verify

			end
		elsif @message[:type] == "postback"
			data = @message[:data]
			controller("#{data[:controller]}_controller").send(data[:action])
		else
			raise "unknown type: #{message[:type]}"
		end
	end

	def controller(controller)
		eval("LinebotWebhook::Controllers::#{controller.camelize}").new(@clinic, @line_account, @message)
	end

end

