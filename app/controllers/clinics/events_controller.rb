class ::Clinics::EventsController < ::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "event",
      new_resource: proc { @clinic.events.new},
      find_resource: proc { @clinic.events.find(params[:id])},
      resource_params: proc { params.require(:event).permit(@event.class.accessable_atts)}
    })
  }

  def index
    @events = @clinic.events
    @events = @events.page(params[:page]).per(20)

    @doctors = @clinic.doctors
    @date = Date.parse(params[:date]) rescue Date.today
  end

end
