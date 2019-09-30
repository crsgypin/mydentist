module Linebot::Clinics::Webhook::Handler::Events

	def event_index
		@patient = @line_account.patient
		if @patient.nil?
			reply_message({
				type: "text",
				text: "抱歉您尚未填寫個人資料"
			})
		end
	end

	def event_new(data)
		step = data[:step]
		if step == 0
			@line_account.update({
				dialog_status: "預約掛號",
				dialog_status_step: 1
			})
			reply_message({
				type: "quick_reply_buttons",
				text: "請選擇服務項目",
				items: @clinic.services.map do |service|
					r = {
						dialog_status: "預約掛號",
						dialog_status_step: 1,
						name: service.name,
						data: {
							key: "event_create", 
							service_name: service.name
						}
					}
				end
			})
		elsif step == 1
			raise "invalid_status"

			@line_account.update({
				dialog_status: "預約掛號",
				dialog_status_step: 2,
			})

		else
			raise "invalid_status"
		end
	end

end
