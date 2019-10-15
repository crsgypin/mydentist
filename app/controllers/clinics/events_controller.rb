class ::Clinics::EventsController < ::Clinics::ApplicationController

  def index
    @events = @clinic.events
    @events = @events.page(params[:page]).per(20)

    @doctors = @clinic.doctors
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
