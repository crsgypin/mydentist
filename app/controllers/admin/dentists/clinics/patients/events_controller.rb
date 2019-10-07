class Admin::Dentists::Clinics::Patients::EventsController < Admin::Dentists::Clinics::Patients::ApplicationController
  before_action -> {
    access_config({
      variable_name: "event",
      new_resource: proc { @patient.events.new},
      find_resource: proc { @patient.events.find(params[:id])},
      resource_params: proc { params.require(:event).permit(@event.class.accessable_atts)}
    })
  }

  def index
    @events = @patient.events
    @events = @events.page(params[:page]).per(20)
  end

end
