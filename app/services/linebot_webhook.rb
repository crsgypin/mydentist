module LinebotWebhook
	extend ActiveSupport::Concern
  included do
		include LinebotWebhook::Clinics
		include LinebotWebhook::Doctors
		include LinebotWebhook::Events
		include LinebotWebhook::Patients
  end

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

		if @line_account.dialog_status == "無"
			if t == "message"
				if c == "預約掛號"
					event_create
				elsif c == "查詢/取消掛號"
					event_index
				elsif c == "醫師介紹"
					doctors_index
				elsif c == "衛教資訊"
					
				elsif c == "診所資訊"
					clinc_show
				elsif c == "個人設定"
					patient_edit
				end
			end
		elsif @line_account.dialog_status == "選擇項目"
			if t == "postback"
				
			end
		elsif @line_account.dialog_status == "選擇時間"

		elsif @line_account.dialog_status == "預約確認"

		elsif @line_account.dialog_status == "個人設定"

		end
	end

	def handle_verify
		reply_message({
      type: 'text',
      text: "verify"
		})
	end

	def handle_follow
		reply_message({
      type: 'text',
      text: "歡迎加入無想牙醫診所小助手"
		})
	end

	def handle_unfollow
		@line_account.update(status: "unfollow")
	end

end