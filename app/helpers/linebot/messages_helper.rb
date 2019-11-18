module Linebot::MessagesImageHelper

	def linebot_event_confirmation_messages(line_account, event)
		r = []
		r << "#{line_account.display_name}君"
		r << "您的預約為："
		r << "日期: #{event.desc_format(2)}"
		r << "醫生: #{event.doctor.name}"
		r << "項目: #{event.service.name}"
		s = r.join("\n")
		s
	end

	def linebot_event_finished_messages(clinic)
		"預約完成\n我們將會在一週前提醒您！\n#{clinic.name}關心您～"
	end

end

