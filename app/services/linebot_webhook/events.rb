module LinebotWebhook::Events

	def event_index
		@patient = @line_account.patient
		if @patient.nil?
			reply_message({
	      type: 'text',
	      text: "抱歉您尚未填寫個人資料"
			})			
		end
	end

	def event_create
		# event = @clinic.events.create(line_account: @line_account)
		m = @clinic.services.map do |service|
			r = {
        type: "action",
        action: {
          type: "postback",
          label: service.name,
          data: service.name,
          displayText: service.name,
        }
			}
		end
		reply_message({
      type: "text",
      text: "請選擇服務項目",
      quickReply: m			
		})
		# reply_message({
  #     type: 'text',
  #     text: "歡迎加入無想牙醫診所小助手"
		# })
	end

end
