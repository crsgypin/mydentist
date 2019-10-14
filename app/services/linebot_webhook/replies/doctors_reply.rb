module LinebotWebhook::Replies::DoctorsReply

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
							type: "uri",
							label: "查詢醫生資訊",
							uri: liff_doctor_url(@clinic, doctor)
						},
						# {
						# 	type: "postback",
						# 	label: "查詢醫生資訊",
						# 	data: {
						# 		controller: "doctors",
						# 		action: "show",
						# 		doctor_id: doctor.id
						# 	}
						# },
						{
							type: "uri",
							label: "預約",
							uri: liff_line_event_url(@clinic, @line_account, doctor)
						}
					]
				}
			end
		})		
	end
	
	# def reply_doctor
	# 	reply_message({
	# 		type: "text",
	# 		text: proc do
	# 			r = []
	# 			r << @doctor.name
	# 			r << "主治: #{@doctor.pro}"
	# 			r << "學經歷: #{@doctor.experience}"
	# 			r.join("\n")
	# 		end.call
	# 	})
	# end

end
