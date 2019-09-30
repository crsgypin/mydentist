module Linebot::Clinics::Webhook::Handler::Model::Events
	include Common::StringHelper

	def event_index
		@patient = @line_account.patient
		if @patient.nil?
			reply_message({
				type: "text",
				text: "抱歉您尚未填寫個人資料"
			})
		end
	end

	def event_new(message = {})
		if @line_account.dialog_status_step.nil?
			event_new_select_services(message)
		elsif @line_account.dialog_status_step == 1
			event_new_select_doctors(message)
		elsif @line_account.dialog_status_step == 2
			event_new_select_datetime(message)
		else
			raise "invalid_status"
		end
	end

	private

	def event_new_select_services(message)
		@line_account.update({
			dialog_status: "預約掛號",
			dialog_status_step: 1
		})
		reply_message({
			type: "quick_reply_buttons",
			text: "請選擇服務項目",
			items: @clinic.services.map do |service|
				r = {
					name: service.name,
					data: {
						service_name: service.name
					}
				}
			end
		})
	end

	def event_new_select_doctors(message)
		if message[:type] == "message"
			raise "invalid_status"
		elsif message[:type] == "postback"
			service_name = message[:content][:service_name]
		end
		service = @clinic.services.find_by(name: service_name)
		if service.nil?
			return reply_message({
				type: "text",
				text: "找不到此服務"
			})
		end

		@line_account.update({
			dialog_status: "預約掛號",
			dialog_status_step: 2,
		})
		reply_message({
			type: "carousel",
			text: "請選擇醫生",
			columns: @clinic.doctors.map do |doctor|
				r = {
					image_url: doctor.image.url,
					title: "#{doctor.name} #{doctor.title}",
					text: short_string(doctor.pro, 39),
					name: doctor.name,
					default_action: {
						type: "postback",
						label: doctor.name,
						data: {doctor_id: doctor.id}
					},
					actions: [
						{
							type: "uri",
							label: "查詢醫生資訊",
							uri: "https://dentist.gypin.life"
						},
						{
							type: "postback",
							label: "預約",
							data: {doctor_id: doctor.id}
						}
					]
				}
			end
		})
	end

	def event_new_select_datetime(message)
		reply_message({
			type: "text",
			text: "預約時間"
		})
	end

end
