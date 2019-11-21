module LinebotWebhook::Replies::PatientReply
	include Common::DateHelper
  include Linebot::MessagesHelper

  def patient_info(patient)
  	r = ""
		r += "姓名: #{patient.name}\n"
		r += "生日: #{patient.birthday.strftime("%Y年%m月%d日")}\n"
		r += "手機: #{patient.phone}\n"
		r
  end

	def reply_to_fill_name
		reply_message({
			type: "text",
			text: "請輸入健保卡的姓名。\n外籍人士，可輸入英文名字。",
		})
	end

	def reply_to_check_patient
		r = reply_message({
			type: "reply_button",
			alt_text: "個人資料",
			title: "個人資料",
			text: proc do
				r = patient_info(@patient)
				r
			end.call,
			actions: [
				{
					type: "postback",
					label: "變更姓名",
					data: {
						controller: "patient",
						action: "update_note",
						type: "name"
					}
				},
				{
					type: "postback",
					label: "變更生日",
					data: {
						controller: "patient",
						action: "update_note",
						type: "birthday"
					}
				},
				{
					type: "postback",
					label: "變更手機號碼",
					data: {
						controller: "patient",
						action: "update_note",
						type: "phone"
					}
				},
			]
		})
	end

	def reply_invalid_name_format
		reply_message({
			type: "text",
			text: "名字格式錯誤，請再輸入一次",
		})		
	end

	def reply_to_fill_birthday
		reply_message({
			type: "text",
			text: "請輸入您的出生年月日\n範例：西元1991年07月08日，請輸入19910708",
		})
	end

	def reply_invalid_birthday_format
		reply_message({
			type: "text",
			text: "生日格式錯誤，請再輸入一次",
		})
	end

	def reply_to_fill_phone
		reply_message({
			type: "text",
			text: "請輸入您的手機號碼",
		})
	end

	def reply_invalid_phone_format
		reply_message({
			type: "text",
			text: "手機格式錯誤，請再輸入一次",
		})
	end

	def reply_finished
		reply_message({
			type: "text",
			text: proc do
				r = "您的個人資料為\n"
				r += patient_info(@patient)
				r
			end.call
		})
	end

	def reply_finished_with_event
		[
			reply_message({
				type: "text",
				text: linebot_event_confirmation_messages(@line_account, @event)
			}),
			reply_message({
				type: "text",
				text: linebot_event_finished_messages(@clinic),
			})
		]		
	end

end
