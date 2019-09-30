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

	def event_create(message = {})
		booking_event = @line_account.events.where(status: "預約中")
		if !booking_event.present?
			booking_event = @line_account.events.create(clinic: @clinic, status: "預約中")
			@line_account.update(dialog_status: "預約掛號")
			reply_services
		else
			if message[:type] == "message"
				return 
			end
		end
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

	def reply_confirm_cancel_event
		reply_message({
			type: "confirm",
			alt_text: "確認預約掛號?",
			text: "您目前還在預約掛號中，是否繼續預約掛號?\n",
			actions: [
				{
					type: "postback",
					label: "是",
					data: {}
				}
			]
		})
	end

	def reply_abort
		reply_message({

		})
	end

	def reply_services_menu
		reply_message({
			type: "quick_reply_buttons",
			text: "請選擇服務項目",
			items: @clinic.services.map do |service|
				r = {
					name: service.name,
					data: {
						event: "event_create"
						action: "service",
						service_id: service.id
					}
				}
			end
		})
	end

	def reply_doctors_menu
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
						data: {
							event: "event_create",
							actions: "doctor",
							doctor_id: doctor.id
						}
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
							data: {
								event: "event_create",
								action: "doctor",
								doctor_id: doctor.id
							}
						}
					]
				}
			end
		})
	end

	def event_new_select_datetime(message)
		raise "invalid_status"
		reply_message({
			type: "text",
			text: "預約時間"
		})
	end

end
