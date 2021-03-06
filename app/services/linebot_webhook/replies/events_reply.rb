module LinebotWebhook::Replies::EventsReply
  include Linebot::MessagesHelper
  include Common::DateHelper

	def reply_events
		reply_message({
			type: "carousel",
			text: "您的診療紀錄",
			columns: @events.map do |event|
				r = {
					title: roc_format(event.date, 4),
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

	def reply_event_confirm_reject
		reply_message({
			type: "text",
			text: "預約已取消"
		})
	end

	def reply_event_confirm_ok_reserved
		reply_message({
			type: "text",
			text: linebot_event_finished_messages(@clinic)
		})		
	end

	def reply_event_confirm_ok_lack_patient
		[
			reply_message({
				type: "text",
				text: "如果要進行線上預約的話，需要先填入基本資料才可以進行預約喔！"
			}),
			reply_message({
				type: "text",
				text: "請輸入健保卡的姓名。\n外籍人士，可輸入英文名字。",
			})
		]
	end

end
