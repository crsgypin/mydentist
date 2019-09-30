module Linebot::Clinics::Webhook::Handler
	extend ActiveSupport::Concern
  included do
		include Linebot::Clinics::Webhook::Handler::Clinics
		include Linebot::Clinics::Webhook::Handler::Doctors
		include Linebot::Clinics::Webhook::Handler::Events
		include Linebot::Clinics::Webhook::Handler::Patients
		include Linebot::Clinics::Webhook::Handler::Follow
		include Linebot::Clinics::Webhook::Handler::Other
		include Linebot::Clinics::Webhook::Handler::DataHelper
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
		t = message[:type]
		c = message[:content]

		if t == "unfollow"
			return handle_unfollow
		end
		@line_account.update(status: "follow") if @line_account.status != "follow" #always set to follow except for unfollow
		if t == "follow"
			return handle_follow
		end
		if c == "Hello, world"
			return handle_verify
		end

		begin
		if @line_account.dialog_status.nil?
			if t == "message"
				if c == "預約掛號"
					event_new({step: 0})
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
			end
		elsif @line_account.dialog_status == "預約掛號"
			event_new(message)
		else
			handle_unknown_message
		end
		rescue Exception => e
			if e.to_s == "invalid_status"
				handle_invalid_status(message)
			else
				raise e
			end
		end
	end

end