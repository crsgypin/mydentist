class ::Clinics::EventsController < ::Clinics::ApplicationController
  include Common::DateTimeDurationHelper

  def index
    @doctor_id = params[:doctor_id]
    @date = Date.parse(params[:date]) rescue  Date.today
  
    @segment = params[:segment] || "整日"
    @events = @clinic.events.where(date: @date, status: ["已預約", "報到", "爽約"]).includes(:doctor, :service, :patient).includes(:event_durations)

    if !@doctor_id.present?
      @clinic_wday_hours = @clinic.wday_hours(@date.wday, @segment)    
      @doctors = @clinic.doctors.includes(:events => [:doctor, :service, :patient])
      @doctor_objs = @doctors.map do |doctor|
        r = {
          doctor: doctor,
          hour_segments: doctor.day_hour_events(@date, @clinic_wday_hours)
        }
      end
    else
      @doctor = @clinic.doctors.find(@doctor_id)
      @clinic_wday_hours = @clinic.max_min_hours
      sunday = @date - @date.wday.day
      @doctor_week_hour_events = (0..6).map do |wday|
        date = (sunday + wday.day)
        r = {
          date: date,
          ch_wday: ch_wday(wday),
          hour_segments:  @doctor.day_hour_events(date, @clinic_wday_hours)
        }
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @date = Date.parse(params[:date]) rescue  Date.today
    @event = @clinic.events.new(date: @date)

    if params[:patient_id].present?
      @patient = @clinic.patients.find(params[:patient_id])
    else
      @patient = @clinic.patients.new
    end
  end

  def edit
    @event = @clinic.events.find(params[:id])
    @patient = @event.patient
  end

  def create
    begin
    ActiveRecord::Base.transaction do 
      @patient = @clinic.patients.new(patient_params)
      if !@patient.save
        raise @patient.errors.full_messages.join(",")
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

  def event_params
    params.require(:event).permit(:status, :service_id, :doctor_id, :hour_minute, :source, :date)
  end

  def patient_params
    params.require(:patient).permit(:name, :phone, :person_id, :gender, :year, :month, :day, :source)
  end

end
