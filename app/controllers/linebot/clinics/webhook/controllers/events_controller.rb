module Linebot::Clinics::Webhook::Controllers::EventsController

	def event_index

	end

	def event_create
		if @message[:type] == "message"
			if @message[:text] == "預約掛號"
				@booking_event = @line_account.events.find_or_initialize_by(status: "預約中")
				@line_account.update(dialog_status: "預約掛號")
				replies_event_services
			else
				replies_event_abort_or_select_services
			end
		end
	end

	def event_create_service
		@booking_event = @line_account.events.find_or_initialize_by(status: "預約中")
		@service = @clinic.services.find_by(id: @message[:data][:service_id])
		if !@service
			return replies_event_no_servie
		end
		@booking_event.update(service: @service)
		if @booking_event.doctor.nil?
			replies_event_doctors
		else
			
		end
	end

	def event_create_doctor

	end

	def event_destroy(message)
		booking_event = @line_account.events.find_by(status: "預約中")
		if booking_event.present?
			booking_event.update(status: "預約中取消")
		end

	end

	def event_select_doctors(message)

	end

end