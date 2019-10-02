module LinebotWebhook::Replies::Doctors

	def reply_doctors
		reply_message({
			type: "carousel",
			text: "請選擇醫生",
			columns: @clinic.doctors.map do |doctor|
				r = {
					image_url: doctor.photo.url,
					title: "#{doctor.name} #{doctor.title}",
					text: short_string(doctor.pro, 39),
					name: doctor.name,
					actions: [
						{
							type: "postback",
							label: "查詢醫生資訊",
							data: {
								controller: "doctors",
								action: "show",
								doctor_id: doctor.id
							}
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
	
	def reply_doctor
		reply_message({
			type: "text",
			text: proc do
				r = []
				r << @doctor.name
				r << "主治: #{@doctor.pro}"
				r << "學經歷: #{@doctor.experience}"
				r.join("\n")
			end.call
		})
	end

end
