class Linebot::Clinics::EventController < Linebot::Clinics::ApplicationController
  include JsCrudConcern
  include Common::DateHelper

	def show
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])

		if !params[:event_id].present?
			redirect_to url_for(request.query_parameters.merge({action: :new}))
		else
			redirect_to url_for(request.query_parameters.merge({action: :edit}))
		end
	end

	def new
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@booking_event = @line_account.booking_events.last
		set_doctor
		set_service
		set_date
		set_event_durations
		render "new"
	end

	def edit
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@event = @line_account.events.find_by(params[:event_id])
		set_doctor
		set_service
		set_date
		set_event_durations
		render "edit"
	end

	def create
		if !params[:event][:hour_minute_duration].present?
			return @error_message = "您尚未選擇時間"
		end
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@event = @line_account.events.new
		@event.clinic = @clinic
		@event.patient = @line_account.patient
		@event.status = "已預約"
		@event.assign_attributes(event_params)
		if !@event.save
			 return js_render_model_error @event
		end
		@line_account.update(dialog_status: nil, dialog_status_step: nil)

		@line_account.sendings.create({
    	source: "server",
    	server_type: "push",
    	messages: {
    		type: "text", 
    		text: "您的掛號已成功，醫師: #{@event.doctor.name}, 時間: #{roc_format(@event.date,3) } #{@event.duration_desc}"
    	}
    })
	end

	def update
		if !params[:event][:hour_minute_duration].present?
			return @error_message = "您尚未選擇時間"
		end
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@event = @line_account.events.find_by(id: params[:event_id])
		@event.clinic = @clinic
		@event.patient = @line_account.patient
		@event.status = "已預約"
		if !@event.update(event_params)
			 return js_render_model_error @event
		end
		@line_account.update(dialog_status: nil, dialog_status_step: nil)				

		@line_account.sendings.create({
    	source: "server",
    	server_type: "push",
    	messages: {
    		type: "text", 
    		text: "您的掛號已修正成功，醫師: #{@event.doctor.name}, 時間: #{roc_format(@event.date,3) } #{@event.duration_desc}"
    	}
    })
	end

	private

	def set_doctor
		if params[:doctor_id].present?
			@doctor = @clinic.doctors.find_by(id: params[:doctor_id])
			return if @doctor.present?
		end
		if @event.present?
			@doctor = @event.doctor
			return if @doctor.present?
		end
		if @booking_event.present?
			@doctor = @booking_event.doctor
			return if @doctor.present?
		end
		@doctor = @clinic.doctors.first
	end

	def set_service
		if params[:service_id].present?
			@service = @clinic.services.find_by(id: params[:service_id])
			return if @service.present?
		end
		if @event.present?
			@service = @event.service
			return if @service.present?
		end
		if @booking_event.present?
			@service = @booking_event.service
			return if @service.present?
		end
		@service = @doctor.services.first
	end

	def set_date
		if params[:date].present?
			@date = Date.parse(params[:date]) rescue nil
			return if @date.present?
		end
		if @event.present?
			@date = @event.date
			return if @date.present?
		end
		if @booking.present?
			@date = @booking.date
			return if @date.present?
		end
		@date = Date.today
	end

	def set_event_durations
		@select_event_durations = @doctor.current_event_durations(@date, @service.duration_number)
	end

	def event_params
		params.require(:event).permit(:doctor_id, :service_id, :date, :hour_minute_duration)
	end

end

