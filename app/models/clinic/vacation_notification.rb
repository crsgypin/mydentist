class Clinic::VacationNotification < ApplicationRecord
	belongs_to :vacation
	belongs_to :event
	belongs_to :line_sending, class_name: "Line::Sending", optional: true
	before_create :sending_messages
	include LinebotWebhook::Helper::RepliedMessageHelper

	def sending_messages
		if !self.event.patient || !self.event.patient.line_account.present?
			self.errors.add("無LINE帳號", "")
			throw :abort
		end
		line_account = self.event.patient.line_account
		line_sending = line_account.sendings.create({
    	client_sending: @client_sending,
    	source: "server",
    	server_type: "push",
    	messages: reply_message({
				type: "confirm",
				alt_text: "掛號修改通知",
				text: ClinicLine::System.clinic_vacation_change_note,
				actions: [
					{
						type: "postback",
						label: "否，取消預約",
						data: {
							controller: "clinic_vacation_notifications",
							action: "confirm_abort",
						}
					},
					{
						type: "postback",
						label: "是，修改預約",
						data: {
							controller: "clinic_vacation_notifications",
							action: "confirm_change",
						}
					}
				]
			})
		})
		if line_sending.status != "成功"
			self.errors.add(line_sending.error_message ,"");
			throw :abort
		end
		self.line_sending = line_sending
		true
	end

end
