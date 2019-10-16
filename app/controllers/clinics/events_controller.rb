class ::Clinics::EventsController < ::Clinics::ApplicationController

  def index
    @doctor = params[:doctor]
    @date = Date.parse(params[:date]) rescue  Date.today
  
    @segment = params[:segment] || "整日"
    @events = @clinic.events.where(date: @date).includes(:doctor, :service, :patient)
    
    @doctors = @clinic.doctors.includes(:events => [:doctor, :service, :patient])

    respond_to do |format|
      format.html
      format.js
    end

  end

  def new
    @date = Date.parse(params[:date]) rescue  Date.today
    @event = @clinic.events.new(date: @date)
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
