module LinebotWebhook::Replies::ClinicReply


	def reply_clinic_info_selectors
		r = reply_message({
			type: "reply_button",
			alt_text: "選擇查詢資訊",
			title: "選擇時間",
			text: "點選內容，選擇時間",
      # image_url: @clinic.photo.url,
			actions: [
				{
					type: "postback",
					label: "門診時間",
					data: {
						controller: "clinic",
						action: "show",
						type: "duration"
					}
				},
				{
					type: "postback",
					label: "交通資訊",
					data: {
						controller: "clinic",
						action: "show",
						type: "traffic"
					}
				},
				{
					type: "postback",
					label: "聯絡診所",
					data: {
						controller: "clinic",
						action: "show",
						type: "contact"
					}
				}
			]
		})
		r

	end

	def reply_clinic_duration
		reply_message({
			type: "text",
			text: proc do
				r = "門診時間\n\n"
				r += "週一~週五 PM 02:00~PM 05:00 PM06:00~PM09:00\n"
				r += "週六 PM 02:00~PM 05:00\n"
				r += "週日休診\n"
				r += "國定假日、過年除夕晚上～初五休診"
				r
			end.call
		})
	end

	def reply_clinic_traffic
		reply_message({
			type: "text",
			text: @clinic.address
		})
	end

	def reply_clinic_contact
		reply_message({
			type: "text",
			text: proc do
				r = "Hi #{@line_account.display_name}\n"
				r += "我是#{@clinic.name}小幫手，歡迎使用我們的服務\n"
				r += "我們電話: #{@clinic.phone}"
				r
			end.call
		})
	end

end