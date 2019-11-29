class Linebot::Clinics::EventController < Linebot::Clinics::ApplicationController
  include JsCrudConcern
  include Common::DateHelper
  include Linebot::MessagesHelper

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
		set_doctor_service
		set_date
		set_event_durations
		render "new"
	end

	def edit
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@event = @line_account.events.find_by!(id: params[:event_id])
		set_doctor
		set_doctor_service
		set_date
		set_event_durations
		render "edit"
	end

	def create
		# if !params[:event][:hour_minute_duration].present?
		# 	return @error_message = "您尚未選擇時間"
		# end
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@event = @line_account.events.new
		@event.clinic = @clinic
		if @line_account.patient.present?
			@event.patient = @line_account.patient
			@event.status = "已預約"
		else
			@event.status = "缺少病患資料"
		end
		@event.assign_attributes(event_params)
		if !@event.save
			return js_render_model_error @event
		end

		#清除 LINE 狀態
		@line_account.update(dialog_status: nil, dialog_status_step: nil)

		#發送推播
		push_notification

		#回診推播處理
    check_event_notification
	end

	def update
		if !params[:event][:hour_minute_duration].present?
			return @error_message = "您尚未選擇時間"
		end

    ActiveRecord::Base.transaction do	
		@line_account = @clinic.line_accounts.find_by!(id: params[:line_account_id])
		@event = @line_account.events.find_by!(id: params[:event_id])
		check_event_date
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
    		text: "您的掛號已修正成功\n醫師: #{@event.doctor.name}\n時間: #{roc_format(@event.date,3) } #{@event.duration_desc}"
    	}
    })

    check_event_notification
    end
	end

	private

	def set_doctor
		@doctors = @clinic.doctors
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

	def set_doctor_service
		@doctor_services = @doctor.doctor_services.includes(:service).where("has_line_booking = ?", Doctor::Service.has_line_bookings["有"])
		if params[:service_id].present?
 			@doctor_service = @doctor_services.find{|d| d.service_id == params[:service_id].to_i}
			return if @doctor_service.present?
		end
		if @event.present?
			@doctor_service = @doctor_services.find{|d| d.service == @event.service}
			return if @doctor_service.present?
		end
		if @booking_event.present?
			@doctor_service = @doctor_services.find{|d| d.service == @booking_event.service}
			return if @doctor_service.present?
		end
		@doctor_service = @doctor_services.first
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
		@doctor_day_hour_minute_events = @doctor.day_hour_minute_events(@date, @clinic.wday_hours(@date.wday))
 		@doctor_day_segment_hour_events = ["早上", "下午", "晚上"].map do |segment|
			hours = segment_hours(segment)
			r = {
				name: segment,
				hour_minute_segments: @doctor_day_hour_minute_events.select do |d|
					hours.include?(d[:hour])
				end
			}
		end

		#check for current_duration
		current_duration = @doctor_service.duration
		current_duration_count = @doctor_service.duration_number / Clinic.default_duration

		@doctor_day_segment_hour_events = @doctor_day_segment_hour_events.map do |doctor_day_segment_hour_event|
			hour_minute_segments = doctor_day_segment_hour_event[:hour_minute_segments]
			r = {
				name: doctor_day_segment_hour_event[:name],
				hour_minute_segments: hour_minute_segments.map.with_index do |hour_minute_segment, index|
					allow_booking = true
					if hour_minute_segment[:has_vacation].present?
						allow_booking = false
					end
					if hour_minute_segment[:expired]
						allow_booking = false
					end
					if allow_booking
						current_duration_count.times do |subindex|
							hs = hour_minute_segments[index + subindex]
							if hs.present?
								if hs[:events].find{|e| e.is_valid_in_line?}.present?
									allow_booking = false
								end
							else
								allow_booking = false
							end
						end
					end
					h = {
						hour: hour_minute_segment[:hour],
						minute: hour_minute_segment[:minute],
						allow_booking: allow_booking,
						has_vacation: hour_minute_segment[:has_vacation],
						events: hour_minute_segment[:events],
					}
				end
			}			
		end
	end

	def event_params
		params.require(:event).permit(:doctor_id, :service_id, :date, :hour_minute_duration)
	end

	def check_event_date
		new_date = Date.parse(params[:event][:date]) rescue nil
		if @event.date != new_date
			@ori_event = @event
			@ori_event.update(status: "已改約")
			@event = @line_account.events.new(ori_event: @ori_event)
		end
	end

	def check_event_notification
		if params[:event_notification_id].present?
			@event_notification = Event::Notification.find_by(id: params[:event_notification_id])
			@event_notification.update!(status: "同意", event: @event)
		end
	end

	def push_notification
		@line_account.sendings.create({
			source: "server",
			server_type: "push",
			messages: [
				{
					type: "text",
					text: linebot_event_confirmation_messages(@line_account, @event)
				},
				{
					type: "template",
					altText: "確認資料",
					template: {
						type: "confirm",
						text: "請問您的資料是否正確無誤？",
						actions: [
							{
								type: "postback",
								label: "否",
								data: {
									controller: "events",
									action: "confirm_reject",
									id: @event.id
								}.to_query
							},
							{
								type: "postback",
								label: "是",
								data: {
									controller: "events",
									action: "confirm_ok",
									id: @event.id
								}.to_query
							},
						]
					}
				}
			]
		})
	end
end

