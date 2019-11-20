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
		@booking_event.update(service: @service)

		@patient = @line_account.patient
		if @patient.present? && @patient.default_doctor.present?
			@doctors = @service.doctors.where("doctor_services.has_line_booking = ?", Doctor::Service.has_line_bookings["有"])
			return reply_booking_event_doctors
			@doctor = @patient.default_doctor
			reply_default_doctor
		else
			@doctors = @service.doctors.where("doctor_services.has_line_booking = ?", Doctor::Service.has_line_bookings["有"])
			reply_booking_event_doctors			
		end
	end

	def other_doctors
		@booking_event = @line_account.booking_events.last || @line_account.booking_events.new
		@service = @booking_event.service
		if !@sercice
			reply_booking_event_no_servie
			return
		end
		@doctors = @service.doctors.where("doctor_services.has_line_booking = ?", Doctor::Service.has_line_bookings["有"])
		reply_booking_event_doctors
	end

	def update_doctor
		@booking_event = @line_account.booking_events.last || @line_account.booking_events.new
		@doctor = @clinic.doctors.find_by!(id: @message[:data][:doctor_id])
		@booking_event.update!(doctor: @doctor)
		reply_booking_event_time_durations
	end

	def services

	end

end