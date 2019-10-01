class LinebotWebhook::Controllers::EventsController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::Events

	def index
		
	end

	def create
		if @message[:type] == "message"
			if @message[:text] == "預約掛號"
				@booking_event = @line_account.events.find_or_initialize_by(status: "預約中")
				@booking_event.assign_attributes({
					clinic: @clinic
				})
				@line_account.dialog_status = "預約掛號"
				if !@line_account.save
					puts "gogoge: #{@line_account}"
					raise @line_account.errors.full_messages.join("-")
				end
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
			reply_event_doctors
		end
	end

	def update_doctor
		@booking_event = @line_account.events.find_or_initialize_by(status: "預約中")
		@doctor = @clinic.doctors.find_by(id: @message[:data][:doctor_id])
		@booking_event.update!(doctor: @doctor)
		reply_event_times
	end

	def destroy
		booking_event = @line_account.events.find_by(status: "預約中")
		if booking_event.present?
			booking_event.update(status: "預約中取消")
		end
		reply_event_aborted
	end

	def services

	end

end