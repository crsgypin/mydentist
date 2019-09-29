module Linebot::Clinics::Webhook::Handler::Events

	def event_index
		@patient = @line_account.patient
		if @patient.nil?
			reply_message(convert_message("抱歉您尚未填寫個人資料"))
		end
	end

	def event_new
		# event = @clinic.events.create(line_account: @line_account)
		# m = @clinic.services.map do |service|
		# 	r = {
  #       type: "action",
  #       action: {
  #         type: "postback",
  #         label: service.name,
  #         data: convert_postback_data({key: "event_create", service_name: service.name}),
  #         displayText: service.name,
  #       }
		# 	}
		# end
		reply_message(convert_postback_buttons({
			text: "請選擇服務項目",
			items: @clinic.services.map do |service|
				r = {
					name: service.name,
					data: {
						key: "event_create", 
						service_name: service.name
					}
				}
			end
		}))
	end

end
