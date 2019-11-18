class LinebotWebhook::Controllers::BookingEventsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::BookingEventsReply

	def create
		if @message[:type] == "message"
			if @message[:text] == "預約掛號"
				@booking_event = @line_account.booking_events.last || @line_account.booking_events.new
				@booking_event.assign_attributes({
					clinic: @clinic
				})
				@line_account.dialog_status = "預約掛號"
				if !@line_account.save
					raise @line_account.errors.full_messages.join("-")
				end
				reply_booking_event_services
			else
				reply_event_abort_or_select_services
			end
		end
	end

	def update_service
		@booking_event = @line_account.booking_events.last || @line_account.booking_events.new
		@service = @clinic.services.find_by(id: @message[:data][:service_id])
		if !@service
			return reply_booking_event_no_servie
		end
		@doctors = @service.doctors.where("doctor_services.has_line_booking = ?", Doctor::Service.has_line_bookings["有"])
		@booking_event.update(service: @service)
		if @booking_event.doctor.nil?
			reply_booking_event_doctors
		else
			reply_booking_event_doctors
		end
	end

	def update_doctor
		@booking_event = @line_account.booking_events.last || @line_account.booking_events.new
		@doctor = @clinic.doctors.find_by(id: @message[:data][:doctor_id])
		@booking_event.update!(doctor: @doctor)
		reply_booking_event_times
	end

	def services

	end

end