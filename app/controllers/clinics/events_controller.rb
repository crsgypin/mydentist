class ::Clinics::EventsController < ::Clinics::ApplicationController
  include Common::DateTimeDurationHelper

  def index
    if params[:event_id].present?
      #for search
      @event = @clinic.events.find(params[:event_id])
      @date = @event.date
      @back_to_today_url = url_for if @date != Date.today
      @category = params[:category]
      @events = [@event]
      return index_search_event
    end
 
    @doctor_id = params[:doctor_id]
    @date = Date.parse(params[:date]) rescue  Date.today
    @back_to_today_url = url_for if @date != Date.today
    @category = params[:category]
  
    @events = @clinic.events.valid_events_with_broadcast.where(date: @date).includes(:doctor, :service, :patient).includes(:event_durations)

    if !@doctor_id.present?
      index_set_for_all_doctors
    else
      index_set_for_single_doctor
    end
  end

  def new
    @event = @clinic.events.new
    new_edit_set_doctor
    new_edit_set_service
    new_edit_set_date
    new_edit_set_patient
    new_edit_set_time_duration
  end

  def edit
    @event = @clinic.events.find(params[:id])
    new_edit_set_doctor
    new_edit_set_service
    new_edit_set_date
    new_edit_set_patient
    new_edit_set_time_duration
  end

  def create
    begin
    ActiveRecord::Base.transaction do 
      if params[:patient_id].present?
        @patient = @clinic.patients.find(params[:patient_id])
      else
        @patient = @clinic.patients.new(patient_params)
        @patient.save!
      end
      @event = @clinic.events.new(event_params)
      @event.patient = @patient
      @event.save!
    end
    rescue Exception => e
      # Rails.logger.info "fail to create event: #{e.to_s}, #{e.backtrace.first(10)}"
      # js_render_error e.to_s
    end
  end

  def update
    @event = @clinic.events.find_by(id: params[:id])
    @event.update(event_params)
  end

  def destroy
    @event = @clinic.events.find_by(id: params[:id])
    if params[:do_action] == '1'
      @event.destroy
    end
  end

  private

  def index_search_event
    @range_segments = segments.map{|s| s[:name]}
    @segment = params[:segment]
    @segment = "整日" if !@range_segments.include?(@segment) 

    @clinic_wday_hours = @clinic.wday_hours(@date.wday, @segment)
    @doctors = @clinic.doctors.includes(:events => [:doctor, :service, :patient])
    @doctor_objs = @doctors.map do |doctor|
      r = {
        doctor: doctor,
        hour_minute_segments: doctor.day_hour_minute_events(@date, @clinic_wday_hours, event_id: @event.id)
      }
    end
  end

  def index_set_for_all_doctors
    @range_segments = segments.map{|s| s[:name]}
    @segment = params[:segment]
    @segment = "整日" if !@range_segments.include?(@segment) 

    @clinic_wday_hours = @clinic.wday_hours(@date.wday, @segment)
    @doctors = @clinic.doctors.includes(:events => [:doctor, :service, :patient])
    @doctor_objs = @doctors.map do |doctor|
      r = {
        doctor: doctor,
        hour_minute_segments: doctor.day_hour_minute_events(@date, @clinic_wday_hours)
      }
    end
  end

  def index_set_for_single_doctor
    @range_segments = ["整週", "整日"]
    @segment = params[:segment]
    @segment = "整週" if !@range_segments.include?(@segment) 

    @doctor = @clinic.doctors.find(@doctor_id)

    if @segment == "整週"
      @clinic_wday_hours = @clinic.max_min_hours
      sunday = @date - @date.wday.day
      @doctor_week_hour_events = (0..6).map do |wday|
        date = (sunday + wday.day)
        r = {
          date: date,
          ch_wday: ch_wday(wday),
          hour_minute_segments: @doctor.day_hour_minute_events(date, @clinic_wday_hours)
        }
      end
    elsif @segment == "整日"
      @doctor_day_segment_hour_events = ["早上", "下午", "晚上"].map do |name|
        hours = segment_hours(name)
        r = {
          name: name,
          hours: hours,
          hour_minute_segments: @doctor.day_hour_minute_events(@date, hours) 
        }
      end
    end
  end

  def new_edit_set_doctor
    @doctors = @clinic.doctors
    if params[:doctor_id].present?
      @doctor = @doctors.find_by(id: params[:doctor_id])
      return if @doctor.present?
    end
    if @event.present?
      @doctor = @doctors.find{|d| d == @event.doctor}
      return if @doctor.present?
    end
    @doctor = @doctors.first    
  end

  def new_edit_set_service
    @services = @doctor.services.includes(:doctor_services).select{|s| s.doctor_services.length > 0}
    if params[:service_id].present?
      @service = @doctor.services.find_by(id: params[:service_id])
      return if @service.present?
    end
    if @event.present?
      @service = @event.service
      return if @service.present?
    end
    @service = @services.first
  end

  def new_edit_set_date
    if params[:date].present?
      @date = Date.parse(params[:date]) rescue nil
      return if @date.present?
    end
    if @event.present?
      @date = @event.date
      return if @date.present?
    end
    @date = Date.today    
  end

  def new_edit_set_patient
    if params[:patient_id].present?
      #search patient_id
      @patient = @clinic.patients.find(params[:patient_id])
      return if @patient.present?
    end
    if @event.present?
      @patient = @event.patient
      return if @patient.present?
    end
    @patient = @clinic.patients.new
  end

  def new_edit_set_time_duration
    #duration 不從 event 取出，因為 service 與 doctor 就可以決定

    #hour
    if params[:hour]
      @hour = params[:hour].to_i
    elsif @event.present?
      @hour = @event.hour
    else
      @hour = nil
    end

    #minute
    if params[:minute]
      @minute = params[:minute].to_i
    elsif @event.present?
      @minute = @event.minute
    else
      @minute = nil
    end

    #duration
    if params[:duration].present? && params[:duration].to_i > 15
      @duration = params[:duration].to_i
    else
      @doctor_service = @service.doctor_services.find{|s| s.doctor == @doctor}
      @duration = @doctor_service.duration_number
    end
  end

  def event_params
    params.require(:event).permit(:status, :service_id, :doctor_id, :hour_minute, :source, :date, :health_insurance_status, :hour, :minute, :duration)
  end

  def patient_params
    params.require(:patient).permit(:name, :phone, :person_id, :gender, :year, :roc_year, :month, :day, :source)
  end

end
