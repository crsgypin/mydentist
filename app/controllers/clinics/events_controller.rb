class ::Clinics::EventsController < ::Clinics::ApplicationController

  def index
    @date = Date.parse(params[:date]) rescue  Date.today
    @events = @clinic.events.where(date: @date).includes(:doctor, :service, :patient)
    
    @doctors = @clinic.doctors.includes(:events => [:doctor, :service, :patient])
    @date = Date.parse(params[:date]) rescue Date.today
  end

  def update
    @event = @clinic.events.find_by(id: params[:id])
    @event.update(event_params)
  end

  private

  def event_params
    params.require(:event).permit(:status)
  end

end
