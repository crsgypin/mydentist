module LinebotWebhook::Replies::Events

	def reply_event_services
		reply_message({
			type: "quick_reply_buttons",
			text: "請選擇服務項目",
			items: @clinic.services.map do |service|
				r = {
					type: "postback",
					label: service.name,
					displayText: service.name,
					data: {
						controller: "events",
						action: "update_service",
						service_id: service.id
					}
				}
			end
		})
	end

	def reply_event_doctors		
		reply_message({
			type: "carousel",
			text: "請選擇醫生",
			columns: @clinic.doctors.map do |doctor|
				r = {
					image_url: doctor.photo.url,
					title: "#{doctor.name} #{doctor.title}",
					text: short_string(doctor.pro, 39),
					name: doctor.name,
					# default_action: {
					# 	type: "postback",
					# 	label: doctor.name,
					# 	data: {
					# 		controller: "events",
					# 		action: "update_doctor",
					# 		doctor_id: doctor.id
					# 	}
					# },
					actions: [
						{
							type: "uri",
							label: "查詢醫生資訊",
							uri: "https://dentist.gypin.life"
						},
						proc do
							# host = Rails.application.config_for(:api_key)["base_domain"]
							# url = Rails.application.routes.url_helpers.linebot_clinic_event_url(@clinic, line_account_id: @line_account.id, doctor_id: doctor.id, host: host)
							r = {
								type: "uri",
								label: "預約",
								uri: liff_line_event_url(@clinic, @line_account, doctor)
							}
						end.call
						# {
						# 	type: "postback",
						# 	label: "預約",
						# 	data: {
						# 		controller: "events",
						# 		action: "update_doctor",
						# 		doctor_id: doctor.id
						# 	}
						# }
					]
				}
			end
		})
	end

	def reply_event_times
		# current not used, noted at 2019/10/1
		# url = Rails.application.routes.url_helpers.linebot_clinic_event_url(@clinic, line_account_id: @line_account.id, host: Rails.application.config_for(:api_key)["base_domain"])
		url = liff_line_event_url(@clinic, @line_account)
		r = reply_message({
			type: "reply_button",
			alt_text: "選擇時間",
			title: "選擇時間",
			text: "點選內容，選擇時間",
      image_url: @doctor.photo.url,
			default_action: {
        type: "uri",
        label: "醫生",
        uri: url
			},
			actions: [
				{
					type: "uri",
					label: "選擇時間",
					uri: url
				}
			]
		})
		r
	end

	def reply_event_abort_or_select_services
		reply_message({
			type: "confirm",
			alt_text: "取消或繼續預約",
			text: "您目前還在預約掛號中，是否繼續預約?",
			actions: [
				{
					type: "postback",
					label: "否，取消預約",
					data: {
						controller: "events",
						action: "destroy",
					}
				},
				{
					type: "postback",
					label: "是，繼續預約",
					data: {
						controller: "events",
						action: "services",
					}
				}
			]
		})
	end

	def reply_event_aborted
		reply_message({
			type: "text",
			text: "預約已取消"
		})
	end

	def reply_event_no_servie
		reply_message({
			type: "text",
			text: "無此醫療項目"
		})
	end

end
