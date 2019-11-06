module LinebotWebhook::Replies::EventsReply

	def reply_events
		reply_message({
			type: "carousel",
			text: "您的診療紀錄",
			columns: @events.map do |event|
				r = {
					title: event.date.strftime("%Y/%m/%d"),
					text: proc do 
						r = "醫生: #{event.doctor.name}\n"
						r += "項目: #{event.service.name}\n"
						r += "時段: #{event.desc_format(2)}"
						r
					end.call,
					name: "有預約",
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
							label: "變更約診",
							uri: liff_line_event_url(@clinic, @line_account, {event_id: event.id})
						},
						{
							type: "postback",
							label: "取消約診",
							data: {
								controller: "events",
								action: "confirm_destroy",
								id: event.id
							}
						},
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

	def reply_no_events
		reply_message({
			type: "text",
			text: "您尚無掛號紀錄"
		})
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
						status: "預約中"
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

	def reply_confirm_destroy
		reply_message({
			type: "confirm",
			alt_text: "確認取消？",
			text: "你是否取消預約？",
			actions: [
				{
					type: "postback",
					label: "否",
					data: {
						controller: "events",
						action: "index",
					}
				},
				{
					type: "postback",
					label: "是",
					data: {
						controller: "events",
						action: "destroy",
						status: "已預約",
						id: @event.id
					}
				}
			]
		})
	end

	def reply_event_destroyed
		reply_message({
			type: "text",
			text: "預約已取消"
		})
	end

end
