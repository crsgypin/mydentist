class LinebotWebhook::Controllers::EventsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::Events

	def index
		
	end

	def create
		if @message[:type] == "message"
			if @message[:text] == "預約掛號"
				@booking_event = @line_account.events.find_or_initialize_by(status: "預約中")
				@line_account.update(dialog_status: "預約掛號")
				reply_event_services
			else
				reply_event_abort_or_select_services
			end
		end
	end

	def update_service
		@booking_event = @line_account.events.find_or_initialize_by(status: "預約中")
		@service = @clinic.services.find_by(id: @message[:data][:service_id])
		if !@service
			return reply_event_no_servie
		end
		@booking_event.update(service: @service)
		if @booking_event.doctor.nil?
			reply_event_doctors
		else

		end
	end

	def update_doctor
		@booking_event = @line_account.events.find_or_initialize_by(status: "預約中")
		@doctor = @clinic.services.find_by(id: @message[:data][:doctor_id])
		if !@service
			return replies
		end

	end

	def destroy
		booking_event = @line_account.events.find_by(status: "預約中")
		if booking_event.present?
			booking_event.update(status: "預約中取消")
		end

	end

	def services

	end

end