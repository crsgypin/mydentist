class ::Clinics::EventsController < ::Clinics::ApplicationController
  include Common::DateTimeDurationHelper

  def index
    @doctor_id = params[:doctor_id]
    @date = Date.parse(params[:date]) rescue  Date.today
  
    @events = @clinic.events.where(date: @date, status: ["已預約", "報到", "爽約"]).includes(:doctor, :service, :patient).includes(:event_durations)

    if !@doctor_id.present?
      set_for_all_doctors
    else
      set_for_single_doctor
    end
  end

  def new
    @date = Date.parse(params[:date]) rescue Date.today
    @event = @clinic.events.new(date: @date)

    if params[:patient_id].present?
      #search patient_id
      @patient = @clinic.patients.find(params[:patient_id])
      return
    end
    @patient = @clinic.patients.new
  end

  def edit
    @event = @clinic.events.find(params[:id])
    @patient = @event.patient
  end

  def create
    begin
    ActiveRecord::Base.transaction do 
      if params[:patient_id].present?
        @patient = @clinic.patients.find(params[:patient_id])
      else
        @patient = @clinic.patients.new(patient_params)
        if !@patient.save
          raise @patient.errors.full_messages.join(",")
        end
      end
      @event = @clinic.events.new(event_params)
      @event.patient = @patient
      if !@event.save
        raise @event.errors.full_messages.join(",")
      end
    end
    rescue Exception => e
      Rails.logger.info "fail to create event: #{e.to_s}, #{e.backtrace.first(10)}"
      @error_message = e.to_s
    end
  end

  def update
    @event = @clinic.events.find_by(id: params[:id])
    @event.update(event_params)
  end

  private

  def set_for_all_doctors
    @range_segments = segments.map{|s| s[:name]}
    @segment = params[:segment]
    @segment = "整日" if !@range_segments.include?(@segment) 

    @clinic_wday_hours = @clinic.wday_hours(@date.wday, @segment)
    @doctors = @clinic.doctors.includes(:events => [:doctor, :service, :patient])
    @doctor_objs = @doctors.map do |doctor|
      r = {
        doctor: doctor,
        hour_segments: doctor.day_hour_events(@date, @clinic_wday_hours)
      }
    end
  end

  def set_for_single_doctor
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
          hour_segments: @doctor.day_hour_events(date, @clinic_wday_hours)
        }
      end
    elsif @segment == "整日"
      @doctor_day_segment_hour_events = ["早上", "下午", "晚上"].map do |name|
        hours = segment_hours(name)
        r = {
          name: name,
          hours: hours,
          hour_segments: @doctor.day_hour_events(@date, hours) 
        }
      end
    end
  end

  def event_params
    params.require(:event).permit(:status, :service_id, :doctor_id, :hour_minute, :source, :date, :health_insurance_status, :hour, :minute, :duration)
  end

  def patient_params
    params.require(:patient).permit(:name, :phone, :person_id, :gender, :year, :month, :day, :source)
  end

end
