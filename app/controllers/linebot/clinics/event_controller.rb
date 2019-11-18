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
    		text: "您的掛號已修正成功，醫師: #{@event.doctor.name}, 時間: #{roc_format(@event.date,3) } #{@event.duration_desc}"
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
 			@doctor_service = @doctor_services.find{|d| d.service_id == params[:service_id]}
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
		# @select_event_durations = @doctor.current_event_durations(@date, @service.duration_number)

		@doctor_day_hour_events = @doctor.day_hour_events(@date, @clinic.wday_hours(@date.wday))
		@doctor_day_segment_hour_events = ["早上", "下午", "晚上"].map do |segment|
			hours = segment_hours(segment)
			r = {
				name: segment,
				hour_segments: @doctor_day_hour_events.select do |d|
					hours.include?(d[:hour])
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
			@event_notification.update!(status: "同意")
		end
	end

	def push_notification
		@line_account.sendings.create({
			source: "server",
			server_type: "push",
			messages: [
				{
					type: "text",
					text: proc do
						r = []
						r << "#{@line_account.display_name}君"
						r << "您的預約為："
						r << "日期: #{@event.desc_format(2)}"
						r << "醫生: #{@event.doctor.name}"
						r << "項目: #{@event.service.name}"
						s = r.join("\n")
						s
					end.call
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

